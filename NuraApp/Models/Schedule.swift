//
//  Schedule.swift
//  Nura
//
//  Created by Vannya Ade Gunawan on 31/08/26.
//

import Foundation
import FirebaseFirestore

struct Schedule: Codable, Identifiable {
    @DocumentID var id: String?
    
    var userId: String
    var medicationId: String
    var medicationName: String
    
    var date: Date
    var time: String             
    var isTaken: Bool
    var reminderEnabled: Bool
    
    var createdAt: Date
}
