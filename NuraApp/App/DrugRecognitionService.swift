import Foundation
import Vision
import CoreML
import UIKit

public struct RecognizedDrug: Identifiable, Codable, Equatable {
    public let id: String // drug_id
    public let name: String
    public let confidence: Double
    public let sourceText: String
}

final class DrugRecognitionService {
    private let vectorizer: TFIDFVectorizer
    private let repo: DrugsRepository

    init(vectorizer: TFIDFVectorizer = TFIDFVectorizer(), repo: DrugsRepository = DrugsRepository()) {
        self.vectorizer = vectorizer
        self.repo = repo
    }

    // MARK: - Public API
    public func recognizeDrug(in image: UIImage) async throws -> RecognizedDrug? {
        let lines = try await ocrText(from: image)
        guard !lines.isEmpty else { return nil }
        let rawText = lines.joined(separator: "\n")
        let preprocessed = preprocess(rawText)
        let candidates = extractCandidates(from: preprocessed)
        guard !candidates.isEmpty else { return nil }

        // Vectorize candidates
        let vectored = try vectorizer.transform(candidates: candidates)

        // Load model
        let model = try DrugClassifier(configuration: MLModelConfiguration())

        var best: (id: String, confidence: Double, candidate: String)? = nil
        for (candidate, features) in vectored {
            // Attempt prediction via common generated APIs
            let result = ModelIO.predict(model: model, features: features)
            guard let result else { continue }
            if best == nil || result.confidence > best!.confidence {
                best = (id: result.label, confidence: result.confidence, candidate: candidate)
            }
        }

        guard let best else { return nil }
        let info = repo.info(for: best.id)
        let name = info?.name ?? best.id
        return RecognizedDrug(id: best.id, name: name, confidence: best.confidence, sourceText: rawText)
    }

    // MARK: - OCR
    private func ocrText(from image: UIImage) async throws -> [String] {
        return try await withCheckedThrowingContinuation { continuation in
            let request = VNRecognizeTextRequest { request, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    continuation.resume(returning: [])
                    return
                }
                let lines: [String] = observations.compactMap { $0.topCandidates(1).first?.string }
                continuation.resume(returning: lines)
            }
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true
            request.recognitionLanguages = ["id-ID", "en-US"]

            let handler: VNImageRequestHandler
            if let cg = image.cgImage {
                handler = VNImageRequestHandler(cgImage: cg, options: [:])
            } else if let data = image.pngData(), let ci = CIImage(data: data) {
                handler = VNImageRequestHandler(ciImage: ci, options: [:])
            } else {
                continuation.resume(returning: [])
                return
            }
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try handler.perform([request])
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    // MARK: - Preprocessing
    private func preprocess(_ text: String) -> String {
        let lower = text.lowercased()
        let noDiacritics = lower.folding(options: .diacriticInsensitive, locale: .current)
        let allowed = noDiacritics.map { ch -> Character in
            if ch.isLetter || ch.isNumber || ch == " " || ch == "\n" { return ch }
            return " "
        }
        let cleaned = String(allowed)
        let collapsed = cleaned.replacingOccurrences(of: "[\n\r]+", with: "\n", options: .regularExpression)
            .replacingOccurrences(of: " +", with: " ", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return collapsed
    }

    private func extractCandidates(from text: String) -> [String] {
        var set = Set<String>()
        set.insert(text)
        text.components(separatedBy: CharacterSet.whitespacesAndNewlines)
            .filter { $0.count > 2 }
            .forEach { set.insert($0) }
        return Array(set)
    }

    // MARK: - ModelIO helper
    private struct ModelIO {
        let label: String
        let confidence: Double

        static func predict(model: DrugClassifier, features: MLMultiArray) -> ModelIO? {
            // Try common API: prediction(input:)
            if let input = try? DrugClassifierInput(features: features),
               let out = try? model.prediction(input: input) {
                return extract(from: out)
            }
            // Try alternative convenience
            if let out = try? model.prediction(features: features) {
                return extract(from: out)
            }
            return nil
        }

        private static func extract(from out: Any) -> ModelIO? {
            // 1) Try to read classLabel and classLabelProbs via KVC if available
            if let probs = (out as AnyObject).value(forKey: "classLabelProbs") as? [String: Double] {
                if let label = (out as AnyObject).value(forKey: "classLabel") as? String,
                   let p = probs[label] {
                    return ModelIO(label: label, confidence: p)
                }
                // No explicit label provided: choose argmax
                if let (bestLabel, bestP) = probs.max(by: { $0.value < $1.value }) {
                    return ModelIO(label: bestLabel, confidence: bestP)
                }
            }

            // 2) If classLabelProbs not present, scan properties for any [String: Double]
            let mirror = Mirror(reflecting: out)
            for child in mirror.children {
                if let probs = child.value as? [String: Double], !probs.isEmpty {
                    if let (bestLabel, bestP) = probs.max(by: { $0.value < $1.value }) {
                        return ModelIO(label: bestLabel, confidence: bestP)
                    }
                }
            }

            // 3) As a fallback, try to read a string label and assume confidence 1.0
            if let label = (out as AnyObject).value(forKey: "classLabel") as? String {
                return ModelIO(label: label, confidence: 1.0)
            }

            return nil
        }
    }
}
