//
//  HomeView.swift
//  Nura
//
//  Created by Vannya Ade Gunawan on 31/08/26.
//


import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    let userId: String
    let userName: String
    var body: some View {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {

                    // MARK: Header
                    header

                    // MARK: Medication Summary
                    medicationSummary

                    // MARK: Quick Access
                    quickAccess

                    // MARK: Recent Articles
                    recentArticles
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 20)
            }
        .background(Color(.systemGroupedBackground))
        .task {
            async let meds: () = viewModel.loadTodayMedications(userId: userId)
            async let arts: () = viewModel.loadRecentArticles()
            _ = await (meds, arts)
        }
    }

    // MARK: - Header
    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 34, height: 34)
                    .overlay {
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)
                    }

                Spacer()

                Button {
                    // Notification action
                } label: {
                    Image(systemName: "bell")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                        .frame(width: 36, height: 36)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(
                            color: .black.opacity(0.08),
                            radius: 5,
                            y: 2
                        )
                }
            }

            VStack(alignment: .leading, spacing: 2) {
                Text("Halo, \(userName)!")
                    .font(.system(size: 26, weight: .bold))

                Text(
                    viewModel.todayMedications.isEmpty
                    ? "Tidak ada obat untuk hari ini."
                    : "Kamu ada \(viewModel.todayMedications.count) obat untuk hari ini."
                )
                .font(.system(size: 13))
                .foregroundColor(.secondary)
            }
        }
    }

    // MARK: - Medication Summary

    private var medicationSummary: some View {
        VStack(spacing: 12) {

            HStack {
                statisticItem(
                    value: "80%",
                    title: "Tepat Waktu"
                )

                statisticItem(
                    value: "20%",
                    title: "Terlambat"
                )

                statisticItem(
                    value: "5x",
                    title: "Tidak Dikonsumsi"
                )
            }

            if let medication = viewModel.todayMedications.first {
                medicationCard(medication)
            } else {
                emptyMedicationCard
            }
        }
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(
            color: .black.opacity(0.08),
            radius: 5,
            y: 2
        )
    }

    private func statisticItem(
        value: String,
        title: String
    ) -> some View {
        VStack(spacing: 3) {
            Text(value)
                .font(.system(size: 17, weight: .bold))

            Text(title)
                .font(.system(size: 10))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    private func medicationCard(_ medication: Medication) -> some View {
        HStack(spacing: 12) {

            Image(systemName: "pills.fill")
                .font(.system(size: 22))
                .foregroundColor(Color("PrimaryBlue"))
                .frame(width: 44, height: 44)
                .background(Color("PrimaryBlue").opacity(0.1))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(medication.name)
                    .font(.system(size: 15, weight: .semibold))

                Text(
                    "\(medication.frequencyPerDay)x Sehari • \(medication.dosage)"
                )
                .font(.system(size: 11))
                .foregroundColor(.secondary)

                if let firstTime = medication.consumptionTimes.first {
                    Text(firstTime)
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            Text("Dikonsumsi")
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(Color("PrimaryBlue"))
                .padding(.horizontal, 9)
                .padding(.vertical, 5)
                .background(Color("PrimaryBlue").opacity(0.1))
                .clipShape(Capsule())
        }
    }
    
    private var emptyMedicationCard: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)

            Text("Tidak ada obat yang perlu diminum hari ini.")
                .font(.system(size: 12))

            Spacer()
        }
        .padding(.vertical, 8)
    }

    // MARK: - Quick Access

    private var quickAccess: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Akses Cepat")
                .font(.system(size: 16, weight: .bold))

            HStack(spacing: 0) {
                quickAccessItem(
                    icon: "nurabutton",
                    title: "NURA"
                )

                NavigationLink {
                    ArticleListView()
                } label: {
                    quickAccessItem(
                        icon: "doc.text.fill",
                        title: "Artikel"
                    )
                }

                quickAccessItem(
                    icon: "plus",
                    title: "Tambah"
                )

                quickAccessItem(
                    icon: "bubble.left.and.bubble.right.fill",
                    title: "Konsultasi"
                )
            }
        }
    }

    private func quickAccessItem(
        icon: String,
        title: String
    ) -> some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color("PrimaryBlue").opacity(0.1))
                    .frame(width: 52, height: 52)

                if icon == "nurabutton" {
                    Image(icon)
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: 26, height: 26)
                        .foregroundColor(Color("PrimaryBlue"))
                } else {
                    Image(systemName: icon)
                        .font(.system(size: 21))
                        .foregroundColor(Color("PrimaryBlue"))
                }
            }

            Text(title)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
    }


    // MARK: - Recent Articles
    private var recentArticles: some View {
        VStack(alignment: .leading, spacing: 12) {

            HStack {
                Text("Artikel Terbaru")
                    .font(.system(size: 16, weight: .bold))

                Spacer()

                NavigationLink {
                    ArticleListView()
                } label: {
                    Text("Selengkapnya")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(Color("PrimaryBlue"))
                }
            }

            if viewModel.recentArticles.isEmpty {
                NavigationLink {
                    ArticleListView()
                } label: {
                    VStack(alignment: .leading, spacing: 8) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.15))
                            .frame(height: 110)
                            .overlay {
                                Image(systemName: "newspaper.fill")
                                    .font(.system(size: 28))
                                    .foregroundColor(.gray)
                            }

                        Text("Lihat artikel terbaru")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.primary)

                        Text("Temukan informasi kesehatan terbaru untukmu.")
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                    }
                }
            } else {
                ForEach(viewModel.recentArticles) { article in
                    NavigationLink {
                        ArticleListView()
                    } label: {
                        HStack(alignment: .top, spacing: 14) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(red: 0.1, green: 0.1, blue: 0.25))
                                .frame(width: 90, height: 90)
                                .overlay {
                                    Image(systemName: "pills.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white.opacity(0.8))
                                }

                            VStack(alignment: .leading, spacing: 8) {
                                Text(article.category)
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 5)
                                    .background(Color.green.opacity(0.7))
                                    .clipShape(Capsule())

                                Text(article.title)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.primary)
                                    .lineLimit(2)

                                HStack(spacing: 2) {
                                    Text("read more")
                                        .font(.system(size: 12))
                                        .foregroundColor(.secondary)
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 10, weight: .semibold))
                                        .foregroundColor(.secondary)
                                }
                            }

                            Spacer(minLength: 0)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeView(
            userId: "preview-user",
            userName: "Lewis"
        )
    }
}
