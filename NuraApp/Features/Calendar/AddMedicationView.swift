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

    @State private var isSaving = false
    @State private var errorMessage: String?

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
                        in: startDate...,
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

                    // Note: when frequency > 1, doses are auto-spaced evenly
                    // across 24h starting from "Waktu Konsumsi" (e.g. 2x/day
                    // → every 12h). A proper "Detail Waktu Konsumsi" picker
                    // for setting each dose time individually isn't wired up
                    // yet — happy to build that next if you want exact times.
                    if frequency > 1 {
                        Text("Jadwal otomatis: \(generateTimes().joined(separator: ", "))")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 4)
                    }

                    Button {
                        save()
                    } label: {
                        if isSaving {
                            ProgressView()
                                .tint(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .background(Color("PrimaryBlue"))
                                .clipShape(Capsule())
                        } else {
                            Text("Simpan")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .background(Color("PrimaryBlue"))
                                .clipShape(Capsule())
                        }
                    }
                    .disabled(isSaving || medicationName.isEmpty)
                    .padding(.top, 5)
                }
                .padding(16)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Tambah Obat")
            .navigationBarTitleDisplayMode(.inline)
            .alert(
                "Gagal menyimpan",
                isPresented: Binding(
                    get: { errorMessage != nil },
                    set: { if !$0 { errorMessage = nil } }
                )
            ) {
                Button("OK", role: .cancel) { errorMessage = nil }
            } message: {
                Text(errorMessage ?? "")
            }
        }
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 14, weight: .bold))
    }

    // MARK: - Save

    private func save() {
        guard !medicationName.isEmpty else { return }
        isSaving = true

        Task {
            do {
                let now = Date()

                let medication = Medication(
                    userId: userId,
                    name: medicationName,
                    dosage: dosage,
                    type: medicationType,
                    imageUrl: nil,
                    startDate: Calendar.current.startOfDay(for: startDate),
                    endDate: Calendar.current.startOfDay(for: endDate),
                    frequencyPerDay: frequency,
                    consumptionTimes: generateTimes(),
                    status: "active",
                    createdAt: now,
                    updatedAt: now
                )

                let medicationId = try FirestoreService().addMedication(medication)
                let schedules = generateSchedules(medicationId: medicationId, medication: medication)
                try await FirestoreService().addSchedules(schedules)

                isSaving = false
                onSaved()
                dismiss()
            } catch {
                isSaving = false
                errorMessage = error.localizedDescription
            }
        }
    }

    /// Auto-spaces `frequency` doses evenly across 24h, starting at
    /// the chosen "Waktu Konsumsi" time. e.g. 2x/day at 08:00 → 08:00, 20:00.
    private func generateTimes() -> [String] {
        let calendar = Calendar.current
        let startComponents = calendar.dateComponents([.hour, .minute], from: selectedTime)
        let startMinutes = (startComponents.hour ?? 8) * 60 + (startComponents.minute ?? 0)
        let interval = (24 * 60) / max(frequency, 1)

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        return (0..<frequency).compactMap { i in
            let totalMinutes = (startMinutes + i * interval) % (24 * 60)
            var comps = DateComponents()
            comps.hour = totalMinutes / 60
            comps.minute = totalMinutes % 60
            guard let date = calendar.date(from: comps) else { return nil }
            return formatter.string(from: date)
        }
    }

    /// One Schedule entry per day in [startDate, endDate] x per dose time,
    /// so the calendar can show "Obat Hari Ini" for every day the
    /// medication is active.
    private func generateSchedules(medicationId: String, medication: Medication) -> [Schedule] {
        var schedules: [Schedule] = []
        let calendar = Calendar.current
        var currentDate = medication.startDate
        let lastDate = medication.endDate
        let now = Date()

        while currentDate <= lastDate {
            for consumptionTime in medication.consumptionTimes {
                schedules.append(
                    Schedule(
                        userId: userId,
                        medicationId: medicationId,
                        medicationName: medication.name,
                        date: currentDate,
                        time: consumptionTime,
                        isTaken: false,
                        reminderEnabled: true,
                        createdAt: now
                    )
                )
            }
            guard let next = calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
            currentDate = next
        }

        return schedules
    }
}
