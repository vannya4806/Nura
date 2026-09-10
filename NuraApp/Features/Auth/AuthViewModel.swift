//
//  AuthViewModel.swift
//  Nura
//
//  Created by Vannya Ade Gunawan on 31/08/26.
//

import SwiftUI
import Combine
import Firebase

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isLoggedIn = false
    @Published var needsProfileSetup = false

    @Published var currentUserId: String = ""
    @Published var currentUserName: String = ""

    private let authService = AuthService()
    private let firestoreService = FirestoreService()

    func register(email: String, password: String, name: String) async {
        isLoading = true
        errorMessage = nil
        do {
            let userId = try await authService.register(email: email, password: password)

            let newUser = User(
                id: userId,
                name: name,
                email: email,
                photoUrl: nil,
                height: 0,
                weight: 0,
                age: 0,
                gender: "",
                diseases: [],
                allergies: [],
                additionalNotes: nil,
                createdAt: Date(),
                updatedAt: Date()
            )
            try firestoreService.saveUser(newUser)

            currentUserId = userId
            currentUserName = name

            needsProfileSetup = true
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func login(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        do {
            let userId = try await authService.login(email: email, password: password)
            currentUserId = userId

            // Ambil nama user dari Firestore
            if let user = try? await firestoreService.fetchUser(userId: userId) {
                currentUserName = user.name
            }

            isLoggedIn = true
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func completeProfileSetup() {
        needsProfileSetup = false
        isLoggedIn = true
    }

    func logout() {
        try? authService.logout()
        isLoggedIn = false
        needsProfileSetup = false
        currentUserId = ""
        currentUserName = ""
    }
}
