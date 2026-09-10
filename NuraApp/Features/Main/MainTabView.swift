//
//  MainTabView.swift
//  NuraApp
//
//  Created by Vannya Ade Gunawan on 10/09/26.
//

import SwiftUI

struct MainTabView: View {
    let userId: String
    let userName: String

    @State private var selectedTab: MainTab = .beranda

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case .beranda:
                        HomeView(userId: userId, userName: userName)
                    case .kalender:
                        CalendarView(userId: userId)
                    case .nura:
                        AIScanView(userId: userId)
                    case .riwayat:
                        HistoryView(userId: userId)
                    case .profil:
                        ProfileView(userId: userId)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                BottomNavBar(selectedTab: $selectedTab)
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

#Preview {
    MainTabView(userId: "preview-user", userName: "Lewis")
}
