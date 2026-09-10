//
//  AddMedicationView.swift
//  Nura
//
//  Created by Vannya Ade Gunawan on 03/09/26.
//

import SwiftUI

struct AddMedicationView: View {
    @Environment(\.dismiss) private var dismiss

    let userId: String
    let onSaved: () -> Void

    @State private var medicationName = ""
    @State private var dosage = ""
    @State private var medicationType = "Tablet"

    @State private var startDate = Date()
    @State private var endDate = Date()

    @State private var frequency = 1
    @State private var selectedTime = Date()

    let medicationTypes = [
        "Tablet",
        "Kapsul",
        "Sirup",
        "Salep",
        "Lainnya"
    ]

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {

                    // MARK: Photo

                    VStack(spacing: 8) {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 80, height: 80)
                            .overlay {
                                Image(systemName: "camera.fill")
                                    .foregroundColor(.gray)
                            }

                        Button("Tambah Foto") {
                            // Camera / photo picker nanti
                        }
                        .font(.system(size: 10))
                        .foregroundColor(.primary)
                    }
                    .frame(maxWidth: .infinity)

                    // MARK: Medication

                    TextField(
                        "Nama Obat",
                        text: $medicationName
                    )
                    .padding(.horizontal, 12)
                    .frame(height: 42)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 9))

                    sectionTitle("Detail Obat")

                    TextField(
                        "Dosis Obat (mg)",
                        text: $dosage
                    )
                    .keyboardType(.decimalPad)
                    .padding(.horizontal, 12)
                    .frame(height: 42)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 9))

                    Picker(
                        "Tipe Obat",
                        selection: $medicationType
                    ) {
                        ForEach(medicationTypes, id: \.self) {
                            Text($0)
                        }
                    }
                    .padding(.horizontal, 12)
                    .frame(height: 42)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 9))

                    // MARK: Consumption

                    sectionTitle("Detail Konsumsi")

                    DatePicker(
                        "Tanggal Mulai",
                        selection: $startDate,
                        displayedComponents: .date
                    )
                    .padding(12)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 9))

                    DatePicker(
                        "Tanggal Selesai",
                        selection: $endDate,
                        displayedComponents: .date
                    )
                    .padding(12)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 9))

                    HStack {
                        Text("Konsumsi Per Hari")

                        Spacer()

                        Stepper(
                            "\(frequency)x",
                            value: $frequency,
                            in: 1...6
                        )
                        .font(.system(size: 11))
                    }
                    .font(.system(size: 11))
                    .padding(12)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 9))

                    DatePicker(
                        "Waktu Konsumsi",
                        selection: $selectedTime,
                        displayedComponents: .hourAndMinute
                    )
                    .padding(12)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 9))

                    Button {
                        save()
                    } label: {
                        Text("Simpan")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(Color("PrimaryBlue"))
                            .clipShape(Capsule())
                    }
                    .padding(.top, 5)
                }
                .padding(16)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Tambah Obat")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 14, weight: .bold))
    }

    private func save() {
        // UI sudah siap.
        //
        // Penyimpanan Medication + Schedule ke Firestore
        // sebaiknya disambungkan setelah kita sesuaikan
        // dengan fungsi FirestoreService yang sudah ada.

        onSaved()
        dismiss()
    }
}
