//
//  BottomNavBar.swift
//  Nura
//
//  Created by Vannya Ade Gunawan on 03/09/26.
//

import SwiftUI

enum MainTab: CaseIterable {
    case beranda, kalender, nura, riwayat, profil

    var title: String {
        switch self {
        case .beranda: return "Beranda"
        case .kalender: return "Kalender"
        case .nura: return "Nura"
        case .riwayat: return "Riwayat"
        case .profil: return "Profil"
        }
    }

    var systemIcon: String {
        switch self {
        case .beranda: return "house.fill"
        case .kalender: return "calendar"
        case .nura: return "" 
        case .riwayat: return "clock.arrow.circlepath"
        case .profil: return "person.fill"
        }
    }
}

struct BottomNavBar: View {
    @Binding var selectedTab: MainTab

    var body: some View {
        HStack(spacing: 0) {
            ForEach(MainTab.allCases, id: \.self) { tab in
                Button {
                    selectedTab = tab
                } label: {
                    if tab == .nura {
                        nuraButton(isSelected: selectedTab == tab)
                    } else {
                        regularTabItem(tab: tab, isSelected: selectedTab == tab)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.top, 10)
        .padding(.bottom, 20)
        .background(
            Color.white
                .shadow(color: .black.opacity(0.06), radius: 6, y: -2)
        )
    }

    private func regularTabItem(tab: MainTab, isSelected: Bool) -> some View {
        VStack(spacing: 4) {
            Image(systemName: tab.systemIcon)
                .font(.system(size: 20))
            Text(tab.title)
                .font(.system(size: 10, weight: .medium))
        }
        .foregroundColor(isSelected ? Color("PrimaryBlue") : .gray)
    }

    private func nuraButton(isSelected: Bool) -> some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(Color("PrimaryBlue"))
                    .frame(width: 42, height: 42)

                Image("nurabutton")
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .foregroundColor(.white)
            }
            .offset(y: -8)
            .shadow(color: Color("PrimaryBlue").opacity(0.4), radius: 4, y: 2)

            Text("Nura")
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(isSelected ? Color("PrimaryBlue") : .gray)
                .offset(y: -4)
        }
    }
}

#Preview {
    VStack {
        Spacer()
        BottomNavBar(selectedTab: .constant(.beranda))
    }
    .ignoresSafeArea(edges: .bottom)
}
