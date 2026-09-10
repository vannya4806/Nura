//
//  ArticleViewModel.swift
//  Nura
//
//  Created by Vannya Ade Gunawan on 31/08/26.
//

import Foundation
import Combine

@MainActor
class ArticleViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let firestoreService = FirestoreService()
    
    func loadArticles() async {
        isLoading = true
        errorMessage = nil
        do {
            articles = try await firestoreService.fetchArticles()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
