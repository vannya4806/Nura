import Foundation
import CoreML

final class TFIDFVectorizer {
    private struct Config: Decodable {
        let vocab: [String: Int]
        let idf: [String: Double]
        let ngram_range: [Int]
        let feature_count: Int
    }

    private var config: Config?
    private let configFileName = "tfidf_config"

    init() {}

    private func loadConfigIfNeeded() throws {
        if config != nil { return }
        guard let url = Bundle.main.url(forResource: configFileName, withExtension: "json") else {
            throw NSError(domain: "TFIDFVectorizer", code: 1, userInfo: [NSLocalizedDescriptionKey: "Missing tfidf_config.json in bundle"])
        }
        let data = try Data(contentsOf: url)
        let cfg = try JSONDecoder().decode(Config.self, from: data)
        self.config = cfg
    }

    func transform(candidates: [String]) throws -> [(String, MLMultiArray)] {
        try loadConfigIfNeeded()
        guard let cfg = config else { return [] }
        var results: [(String, MLMultiArray)] = []
        for text in candidates {
            let grams = ngrams(text: text, minN: cfg.ngram_range.first ?? 3, maxN: cfg.ngram_range.last ?? 5)
            var counts: [Int: Double] = [:]
            for g in grams {
                if let idx = cfg.vocab[g] {
                    counts[idx, default: 0] += 1
                }
            }
            // TF
            let total = max(1.0, counts.values.reduce(0, +))
            for (k, v) in counts { counts[k] = v / total }
            // TF-IDF
            let vector = try MLMultiArray(shape: [NSNumber(value: cfg.feature_count)], dataType: .double)
            for i in 0..<cfg.feature_count { vector[i] = 0 }
            for (idx, tf) in counts {
                if let ng = cfg.vocab.first(where: { $0.value == idx })?.key {
                    let idf = cfg.idf[ng] ?? 1.0
                    vector[idx] = NSNumber(value: tf * idf)
                }
            }
            results.append((text, vector))
        }
        return results
    }

    private func ngrams(text: String, minN: Int, maxN: Int) -> [String] {
        let cleaned = text
        let chars = Array(cleaned)
        var grams: [String] = []
        let maxN = max(minN, maxN)
        for n in minN...maxN {
            if n <= 0 || n > chars.count { continue }
            for i in 0..<(chars.count - n + 1) {
                grams.append(String(chars[i..<(i+n)]))
            }
        }
        return grams
    }
}
