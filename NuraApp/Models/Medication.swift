//
//  Medication.swift
//  Nura
//
//  Created by Vannya Ade Gunawan on 31/08/26.
//

import Foundation
import FirebaseFirestore

struct Medication: Codable, Identifiable {
    @DocumentID var id: String?
    
    var userId: String
    var name: String
    var dosage: String
    var type: String
    var imageUrl: String?
    
    var startDate: Date
    var endDate: Date
    var frequencyPerDay: Int
    var consumptionTimes: [String]
    
    var status: String
    
    var createdAt: Date
    var updatedAt: Date
}
