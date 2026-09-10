//
//  OnboardingViewModel.swift
//  Nura
//
//  Created by Vannya Ade Gunawan on 31/08/26.
//

import Foundation
import Combine
import SwiftUI

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
}

@MainActor
class OnboardingViewModel: ObservableObject {
    @Published var currentPage = 0
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false
    
    let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Belajar Tentang Obatmu",
            description: "Akses ke artikel kesehatan terbaru, info obat, dan tips-tips kesehatan lainnya.",
            imageName: "onboarding_1"
        ),
        OnboardingPage(
            title: "Konsultasi dengan Ahli Gizi",
            description: "Akses konsultasi dengan harga terjangkau ke ahli gizi dan apoteker ternama.",
            imageName: "onboarding_2"
        ),
        OnboardingPage(
            title: "Calender Reminder untuk Obat",
            description: "Reminder harian ke obat-obat yang dimasukkan, sesuai dosis, sesi, dan harian.",
            imageName: "onboarding_3"
        ),
        OnboardingPage(
            title: "OCR untuk Obat yang Ada",
            description: "Memberikan Penjelasan Interaksi antar Obat dan Makanan serta Obat dan Obat.",
            imageName: "onboarding_4"
        )
    ]
    
    var isLastPage: Bool {
        currentPage == pages.count - 1
    }
    
    func next() {
        if currentPage < pages.count - 1 {
            currentPage += 1
        }
    }
    
    func skip() {
        currentPage = pages.count - 1
    }
    
    func finish() {
        hasCompletedOnboarding = true
    }
}
