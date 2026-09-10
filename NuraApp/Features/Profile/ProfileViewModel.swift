//
//  ProfileViewModel.swift
//  Nura
//
//  Created by Vannya Ade Gunawan on 31/08/26.
//

import Foundation
import Combine

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let firestoreService = FirestoreService()
    private let authService = AuthService()
    
    func loadUser(userId: String) async {
        isLoading = true
        errorMessage = nil
        do {
            user = try await firestoreService.fetchUser(userId: userId)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func updateUser(_ updatedUser: User) async {
        do {
            try firestoreService.saveUser(updatedUser)
            user = updatedUser
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func logout() {
        try? authService.logout()
    }
}
