//
//  AuthService.swift
//  Nura
//
//  Created by Vannya Ade Gunawan on 31/08/26.
//

import Foundation
import FirebaseAuth

class AuthService {
    func register(email: String, password: String) async throws -> String {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        return result.user.uid
    }
    
    func login(email: String, password: String) async throws -> String {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return result.user.uid
    }
    
    func logout() throws {
        try Auth.auth().signOut()
    }
    
    var currentUserId: String? {
        Auth.auth().currentUser?.uid
    }
}
