//
//  InformasiDiriViewModel.swift
//  Nura
//
//  Created by Vannya Ade Gunawan on 31/08/26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

@MainActor
class InformasiDiriViewModel: ObservableObject {

    // MARK: Kondisi Tubuh
    @Published var heightText: String = ""
    @Published var weightText: String = ""
    @Published var ageText: String = ""
    @Published var gender: String = ""

    // MARK: Informasi Diri (obat yang sedang dikonsumsi — bisa lebih dari satu via "+ Add On")
    @Published var diseases: [String] = [""]

    // MARK: Alergi Obat & Catatan Tambahan
    @Published var allergy: String = ""
    @Published var additionalNotes: String = ""

    @Published var isLoading = false
    @Published var errorMessage: String?

    private let firestoreService = FirestoreService()

    var isValid: Bool {
        !heightText.isEmpty && !weightText.isEmpty && !ageText.isEmpty && !gender.isEmpty
    }

    func addDiseaseField() {
        diseases.append("")
    }

    func removeDiseaseField(at index: Int) {
        guard diseases.indices.contains(index), diseases.count > 1 else { return }
        diseases.remove(at: index)
    }

    func save() async -> Bool {
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "User tidak ditemukan, silakan login ulang."
            return false
        }

        isLoading = true
        errorMessage = nil

        do {
            let existing = try? await firestoreService.fetchUser(userId: userId)

            let updatedUser = User(
                id: userId,
                name: existing?.name ?? (Auth.auth().currentUser?.displayName ?? ""),
                email: existing?.email ?? (Auth.auth().currentUser?.email ?? ""),
                photoUrl: existing?.photoUrl,
                height: Double(heightText) ?? 0,
                weight: Double(weightText) ?? 0,
                age: Int(ageText) ?? 0,
                gender: gender,
                diseases: diseases.filter { !$0.isEmpty },
                allergies: allergy.isEmpty ? [] : [allergy],
                additionalNotes: additionalNotes.isEmpty ? nil : additionalNotes,
                createdAt: existing?.createdAt ?? Date(),
                updatedAt: Date()
            )

            try firestoreService.saveUser(updatedUser)
            isLoading = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
}
