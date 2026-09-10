//
//  CalendarView.swift
//  Nura
//
//  Created by Vannya Ade Gunawan on 31/08/26.
//

import SwiftUI

struct CalendarView: View {
    @StateObject private var viewModel = CalendarViewModel()

    let userId: String

    @State private var selectedDate = Date()
    @State private var showingAddMedication = false

    private let calendar = Calendar.current

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {

                // Header
                header

                // Month
                monthHeader

                // Calendar
                calendarGrid

                // Medication
                medicationSection
            }
            .padding(16)
        }
        .background(Color(.systemGroupedBackground))
        .sheet(isPresented: $showingAddMedication) {
            AddMedicationView(
                userId: userId,
                onSaved: {
                    Task {
                        await viewModel.loadSchedules(userId: userId)
                    }
                }
            )
        }
        .task {
            await viewModel.loadSchedules(userId: userId)
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Text("Kalender")
                .font(.system(size: 22, weight: .bold))

            Spacer()

            Button {
                showingAddMedication = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(Color("PrimaryBlue"))
                    .clipShape(Circle())
            }
        }
    }

    // MARK: - Month

    private var monthHeader: some View {
        Text(selectedDate.formatted(.dateTime.month(.wide)))
            .font(.system(size: 16, weight: .bold))
    }

    // MARK: - Calendar Grid

    private var calendarGrid: some View {
        VStack(spacing: 10) {

            HStack {
                ForEach(
                    ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"],
                    id: \.self
                ) { day in
                    Text(day)
                        .font(.system(size: 7, weight: .medium))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }

            let days = generateDays()

            LazyVGrid(
                columns: Array(
                    repeating: GridItem(.flexible()),
                    count: 7
                ),
                spacing: 12
            ) {
                ForEach(days, id: \.self) { date in

                    if let date {
                        dateCell(date)
                    } else {
                        Color.clear
                            .frame(height: 32)
                    }
                }
            }
        }
    }

    private func dateCell(_ date: Date) -> some View {
        let isSelected = calendar.isDate(
            date,
            inSameDayAs: selectedDate
        )

        let hasSchedule = !viewModel.schedules(for: date).isEmpty

        return Button {
            selectedDate = date
        } label: {
            VStack(spacing: 3) {

                Text("\(calendar.component(.day, from: date))")
                    .font(.system(size: 11, weight: isSelected ? .bold : .regular))
                    .foregroundColor(
                        isSelected
                        ? Color("PrimaryBlue")
                        : .primary
                    )
                    .frame(width: 28, height: 28)
                    .background(
                        isSelected
                        ? Color("PrimaryBlue").opacity(0.12)
                        : Color.clear
                    )
                    .clipShape(Circle())

                if hasSchedule {
                    Circle()
                        .fill(Color("PrimaryBlue"))
                        .frame(width: 4, height: 4)
                } else {
                    Color.clear
                        .frame(width: 4, height: 4)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }

    // MARK: - Medication

    private var medicationSection: some View {
        VStack(alignment: .leading, spacing: 10) {

            Text("Obat Hari Ini")
                .font(.system(size: 16, weight: .bold))

            let schedules = viewModel.schedules(for: selectedDate)

            if schedules.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "calendar.badge.checkmark")
                        .font(.system(size: 28))
                        .foregroundColor(.gray)

                    Text("Tidak ada obat pada tanggal ini.")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 25)

            } else {
                ForEach(schedules) { schedule in
                    scheduleCard(schedule)
                }
            }
        }
    }

    private func scheduleCard(_ schedule: Schedule) -> some View {
        HStack(spacing: 10) {

            Image(systemName: "pills.fill")
                .font(.system(size: 18))
                .foregroundColor(Color("PrimaryBlue"))
                .frame(width: 38, height: 38)
                .background(
                    Color("PrimaryBlue").opacity(0.1)
                )
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(schedule.medicationName)
                    .font(.system(size: 12, weight: .semibold))

                Text(schedule.time)
                    .font(.system(size: 9))
                    .foregroundColor(.secondary)
            }

            Spacer()

            Text(
                schedule.isTaken
                ? "Dikonsumsi"
                : "Belum"
            )
            .font(.system(size: 8, weight: .medium))
            .foregroundColor(
                schedule.isTaken
                ? .green
                : Color("PrimaryBlue")
            )
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(
                schedule.isTaken
                ? Color.green.opacity(0.1)
                : Color("PrimaryBlue").opacity(0.1)
            )
            .clipShape(Capsule())
        }
        .padding(10)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    // MARK: - Generate Dates

    private func generateDays() -> [Date?] {
        guard let range = calendar.range(
            of: .day,
            in: .month,
            for: selectedDate
        ) else {
            return []
        }

        let firstDay = calendar.date(
            from: calendar.dateComponents(
                [.year, .month],
                from: selectedDate
            )
        )!

        let weekday = calendar.component(
            .weekday,
            from: firstDay
        )

        let leadingEmptyDays = weekday - 1

        var result: [Date?] = Array(
            repeating: nil,
            count: leadingEmptyDays
        )

        for day in range {
            if let date = calendar.date(
                byAdding: .day,
                value: day - 1,
                to: firstDay
            ) {
                result.append(date)
            }
        }

        return result
    }
}
