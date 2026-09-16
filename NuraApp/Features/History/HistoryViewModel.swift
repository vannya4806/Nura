//
//  HistoryViewModel.swift
//  Nura
//
//  Created by Vannya Ade Gunawan on 31/08/26.
//

import Foundation
import Combine

@MainActor
class HistoryViewModel: ObservableObject {
    @Published var scanHistory: [ScanResult] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let firestoreService = FirestoreService()

    func loadHistory(userId: String) async {
        isLoading = true
        errorMessage = nil
        do {
            scanHistory = try await firestoreService.fetchScanHistory(userId: userId)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    /// Deletes a scan result from Firestore and removes it from the
    /// local list so the swipe-to-delete action updates the UI immediately.
    func delete(result: ScanResult) async {
        guard let id = result.id else { return }
        do {
            try await firestoreService.deleteScanResult(id: id)
            scanHistory.removeAll { $0.id == id }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
