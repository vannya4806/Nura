//
//  User.swift
//  Nura
//
//  Created by Vannya Ade Gunawan on 31/08/26.
//

import Foundation
import FirebaseFirestore

struct User: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var email: String
    var photoUrl: String?

    var height: Double
    var weight: Double
    var age: Int
    var gender: String
    
    var diseases: [String]
    var allergies: [String]
    var additionalNotes: String?
    
    var createdAt: Date
    var updatedAt: Date
}
