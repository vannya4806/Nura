//
//  AIScanViewModel.swift
//  Nura
//
//  Created by Vannya Ade Gunawan on 31/08/26.
//

import Foundation
import UIKit
import Combine

enum ScanState: Equatable {
    case idle
    case scanning
    case success
    case failed(String)
}

@MainActor
class AIScanViewModel: ObservableObject {
    @Published var scanState: ScanState = .idle
    @Published var capturedImage: UIImage?
    @Published var result: ScanResult?
    @Published var isSaving = false
    
    private let firestoreService = FirestoreService()
    private let recognitionService = DrugRecognitionService()
    
    func analyze(image: UIImage, userId: String) async {
        capturedImage = image
        scanState = .scanning
        do {
            guard let recognized = try await recognitionService.recognizeDrug(in: image) else {
                scanState = .failed("Maaf! Kami gagal mendeteksi gambar yang Anda ambil. Silakan ambil gambar kembali.")
                return
            }
            
            // TODO: kirim recognized.name ke backend AI Python buat analisis interaksi
            let dummyResult = ScanResult(
                id: nil,
                userId: userId,
                medicationName: recognized.name,
                imageUrl: nil,
                ocrRawText: recognized.sourceText,
                riskStatus: "Aman Dikonsumsi",
                overview: "\(recognized.name) terdeteksi dengan tingkat keyakinan \(Int(recognized.confidence * 100))%.",
                drugInteractions: [],
                foodInteractions: [],
                scannedAt: Date(),
                createdAt: Date()
            )
            result = dummyResult
            scanState = .success
        } catch {
            scanState = .failed("Maaf! Kami gagal mendeteksi gambar yang Anda ambil. Silakan ambil gambar kembali.")
        }
    }
    
    func saveToHistory() async {
        guard let result = result else { return }
        isSaving = true
        defer { isSaving = false }
        
        do {
            try await firestoreService.saveScanResult(result)
        } catch {
            scanState = .failed("Gagal menyimpan hasil scan: \(error.localizedDescription)")
        }
    }
    
    func reset() {
        scanState = .idle
        capturedImage = nil
        result = nil
    }
}
