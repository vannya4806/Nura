//
//  CalendarViewModel.swift
//  Nura
//
//  Created by Vannya Ade Gunawan on 31/08/26.
//

import Foundation
import Combine

@MainActor
class CalendarViewModel: ObservableObject {
    @Published var schedules: [Schedule] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let firestoreService = FirestoreService()
    
    func loadSchedules(userId: String) async {
        isLoading = true
        errorMessage = nil
        do {
            schedules = try await firestoreService.fetchSchedules(userId: userId)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func addSchedule(_ schedule: Schedule) async {
        do {
            try firestoreService.addSchedule(schedule)
            await loadSchedules(userId: schedule.userId)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func schedules(for date: Date) -> [Schedule] {
        schedules.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
}
