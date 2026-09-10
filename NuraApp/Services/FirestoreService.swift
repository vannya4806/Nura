//
//  FirestoreService.swift
//  Nura
//
//  Created by Vannya Ade Gunawan on 31/08/26.
//

import Foundation
import FirebaseFirestore

class FirestoreService {
    private let db = Firestore.firestore()
    
    // MARK: - User
    func saveUser(_ user: User) throws {
        guard let id = user.id else { return }
        try db.collection("users").document(id).setData(from: user)
    }
    
    func fetchUser(userId: String) async throws -> User {
        let snapshot = try await db.collection("users").document(userId).getDocument()
        return try snapshot.data(as: User.self)
    }
    
    // MARK: - Medication
    func addMedication(_ medication: Medication) throws {
        try db.collection("medications").addDocument(from: medication)
    }
    
    func fetchMedications(userId: String) async throws -> [Medication] {
        let snapshot = try await db.collection("medications")
            .whereField("userId", isEqualTo: userId)
            .getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: Medication.self) }
    }
    
    // MARK: - ScanResult (History)
    func saveScanResult(_ result: ScanResult) async throws {
            let ref = db.collection("scanResults").document()
            var data = try Firestore.Encoder().encode(result)
            data["id"] = ref.documentID
            try await ref.setData(data)
        }
    
    func fetchScanHistory(userId: String) async throws -> [ScanResult] {
        let snapshot = try await db.collection("scans")
            .whereField("userId", isEqualTo: userId)
            .order(by: "scannedAt", descending: true)
            .getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: ScanResult.self) }
    }
    
    // MARK: - Schedule
    func addSchedule(_ schedule: Schedule) throws {
        try db.collection("schedules").addDocument(from: schedule)
    }
    
    func fetchSchedules(userId: String) async throws -> [Schedule] {
        let snapshot = try await db.collection("schedules")
            .whereField("userId", isEqualTo: userId)
            .getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: Schedule.self) }
    }
    
    // MARK: - Aritcle
    func fetchArticles() async throws -> [Article] {
        let snapshot = try await db.collection("articles")
            .order(by: "publishedAt", descending: true)
            .getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: Article.self) }
    }
}
