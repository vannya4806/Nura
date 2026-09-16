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
    /// Menyimpan obat baru dan mengembalikan document ID-nya,
    /// supaya bisa langsung dipakai untuk membuat Schedule terkait.
    @discardableResult
    func addMedication(_ medication: Medication) throws -> String {
        let ref = try db.collection("medications").addDocument(from: medication)
        return ref.documentID
    }

    func fetchMedications(userId: String) async throws -> [Medication] {
        let snapshot = try await db.collection("medications")
            .whereField("userId", isEqualTo: userId)
            .getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: Medication.self) }
    }

    func deleteMedication(id: String) async throws {
        try await db.collection("medications").document(id).delete()
    }

    // MARK: - ScanResult (History)
    // PENTING: saveScanResult & fetchScanHistory HARUS memakai collection
    // yang sama. Sebelumnya save() menulis ke "scanResults" sementara
    // fetch() membaca dari "scans", jadi hasil scan yang baru disimpan
    // tidak pernah muncul di Riwayat. Sekarang disatukan ke "scanHistory".
    private let scanHistoryCollection = "scanHistory"

    @discardableResult
    func saveScanResult(_ result: ScanResult) async throws -> String {
        let ref = db.collection(scanHistoryCollection).document()
        var data = try Firestore.Encoder().encode(result)
        data["id"] = ref.documentID
        try await ref.setData(data)
        return ref.documentID
    }

    func fetchScanHistory(userId: String) async throws -> [ScanResult] {
        let snapshot = try await db.collection(scanHistoryCollection)
            .whereField("userId", isEqualTo: userId)
            .order(by: "scannedAt", descending: true)
            .getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: ScanResult.self) }
    }

    func deleteScanResult(id: String) async throws {
        try await db.collection(scanHistoryCollection).document(id).delete()
    }

    // MARK: - Schedule
    @discardableResult
    func addSchedule(_ schedule: Schedule) throws -> String {
        let ref = try db.collection("schedules").addDocument(from: schedule)
        return ref.documentID
    }

    /// Menyimpan banyak Schedule sekaligus (dipakai saat Tambah Obat
    /// membuat satu entri per hari x per waktu konsumsi) dalam satu batch write.
    func addSchedules(_ schedules: [Schedule]) async throws {
        // Firestore batch max 500 operasi, jadi kita potong per 400 biar aman.
        let chunks = stride(from: 0, to: schedules.count, by: 400).map {
            Array(schedules[$0..<min($0 + 400, schedules.count)])
        }
        for chunk in chunks {
            let batch = db.batch()
            for schedule in chunk {
                let ref = db.collection("schedules").document()
                let data = try Firestore.Encoder().encode(schedule)
                batch.setData(data, forDocument: ref)
            }
            try await batch.commit()
        }
    }

    func fetchSchedules(userId: String) async throws -> [Schedule] {
        let snapshot = try await db.collection("schedules")
            .whereField("userId", isEqualTo: userId)
            .getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: Schedule.self) }
    }

    func updateScheduleTaken(id: String, isTaken: Bool) async throws {
        try await db.collection("schedules").document(id).updateData([
            "isTaken": isTaken
        ])
    }

    func deleteSchedule(id: String) async throws {
        try await db.collection("schedules").document(id).delete()
    }

    // MARK: - Article
    func fetchArticles() async throws -> [Article] {
        let snapshot = try await db.collection("articles")
            .order(by: "publishedAt", descending: true)
            .getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: Article.self) }
    }
}
