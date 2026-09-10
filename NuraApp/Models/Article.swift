//
//  Article.swift
//  Nura
//
//  Created by Vannya Ade Gunawan on 31/08/26.
//

import Foundation
import FirebaseFirestore

struct Article: Codable, Identifiable {
    @DocumentID var id: String?
    
    var title: String
    var content: String
    var imageUrl: String?
    var category: String     
    var author: String?
    var publishedAt: Date
}
