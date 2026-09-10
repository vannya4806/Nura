//
//  HomeViewModel.swift
//  Nura
//
//  Created by Vannya Ade Gunawan on 31/08/26.
//

import Foundation
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    @Published var todayMedications: [Medication] = []
    @Published var recentArticles: [Article] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let firestoreService = FirestoreService()

    func loadTodayMedications(userId: String) async {
        isLoading = true
        errorMessage = nil
        do {
            let all = try await firestoreService.fetchMedications(userId: userId)
            let today = Date()
            todayMedications = all.filter { $0.startDate <= today && $0.endDate >= today }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func loadRecentArticles() async {
        do {
            let all = try await firestoreService.fetchArticles()
            recentArticles = Array(all.prefix(2))
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
