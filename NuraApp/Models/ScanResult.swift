//
//  ScanResult.swift
//  Nura
//
//  Created by Vannya Ade Gunawan on 01/09/26.
//

import Foundation
import FirebaseFirestore

struct DrugInteractionItem: Codable {
    var drugName: String
    var riskLevel: String
}

struct FoodInteractionItem: Codable {
    var description: String
    var riskLevel: String
}

struct ScanResult: Codable, Identifiable {
    @DocumentID var id: String?
    
    var userId: String
    var medicationName: String
    var imageUrl: String?
    var ocrRawText: String?
    
    var riskStatus: String
    var overview: String      
    
    var drugInteractions: [DrugInteractionItem]
    var foodInteractions: [FoodInteractionItem]
    
    var scannedAt: Date
    var createdAt: Date
}
