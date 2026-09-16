//
//  HistoryView.swift
//  Nura
//
//  Created by Vannya Ade Gunawan on 03/09/26.
//

import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()
    @State private var searchText = ""
    let userId: String

    var filteredHistory: [ScanResult] {
        if searchText.isEmpty { return viewModel.scanHistory }
        return viewModel.scanHistory.filter {
            $0.medicationName.localizedCaseInsensitiveContains(searchText)
        }
    }

    var last7Days: [ScanResult] {
        let cutoff = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return filteredHistory.filter { $0.scannedAt > cutoff }
    }

    var last30Days: [ScanResult] {
        let sevenCutoff = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        let thirtyCutoff = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
        return filteredHistory.filter {
            $0.scannedAt <= sevenCutoff && $0.scannedAt > thirtyCutoff
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Custom header, matching the mockup's bold "Riwayat" title
            Text("Riwayat")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top, 8)

            // Custom search bar (mic icon included) — .searchable() alone
            // renders the plain system bar, not this look.
            SearchBarView(text: $searchText)
                .padding(.horizontal)
                .padding(.top, 8)

            Group {
                if viewModel.isLoading {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else if filteredHistory.isEmpty {
                    Spacer()
                    emptyView
                    Spacer()
                } else {
                    List {
                        if !last7Days.isEmpty {
                            Section("Previous 7 Days") {
                                ForEach(last7Days) { item in
                                    historyRow(for: item)
                                }
                            }
                        }
                        if !last30Days.isEmpty {
                            Section("Previous 30 Days") {
                                ForEach(last30Days) { item in
                                    historyRow(for: item)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
        }
        .navigationBarHidden(true)
        .task {
            await viewModel.loadHistory(userId: userId)
        }
        .alert(
            "Terjadi kesalahan",
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )
        ) {
            Button("OK", role: .cancel) { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }

    @ViewBuilder
    private func historyRow(for item: ScanResult) -> some View {
        NavigationLink(destination: ScanDetailView(result: item)) {
            HistoryRow(result: item)
        }
        // Swipe-to-delete with the red "Hapus" action shown in the mockup.
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                Task {
                    await viewModel.delete(result: item)
                }
            } label: {
                Label("Hapus", systemImage: "trash")
            }
            .tint(.red)
        }
    }

    private var emptyView: some View {
        VStack(spacing: 12) {
            Image(systemName: "clock.arrow.circlepath")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.gray)
            Text("No Conversations Yet")
                .font(.headline)
            Text("You haven't start any chats.")
                .foregroundColor(.gray)
        }
    }
}

// MARK: - Custom search bar (rounded field + mic icon)

struct SearchBarView: View {
    @Binding var text: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search for medication..", text: $text)
                .textFieldStyle(.plain)
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
            Image(systemName: "mic.fill")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Row (with real medication thumbnail, matching the mockup)

struct HistoryRow: View {
    let result: ScanResult

    var isSafe: Bool {
        result.riskStatus.lowercased().contains("aman") && !result.riskStatus.lowercased().contains("tidak")
    }

    var body: some View {
        HStack(spacing: 12) {
            thumbnail
                .frame(width: 50, height: 66)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text(result.medicationName)
                    .font(.subheadline)
                    .bold()
                RiskBadgeView(isSafe: isSafe, text: result.riskStatus)
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }

    // Falls back to a placeholder icon if there's no image URL yet.
    @ViewBuilder
    private var thumbnail: some View {
        if let urlString = result.imageUrl, let url = URL(string: urlString) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                case .empty:
                    Color.gray.opacity(0.15)
                        .overlay(ProgressView())
                default:
                    placeholderIcon
                }
            }
        } else {
            placeholderIcon
        }
    }

    private var placeholderIcon: some View {
        Color.gray.opacity(0.15)
            .overlay(Image(systemName: "pills.fill").foregroundColor(.gray))
    }
}

struct ScanDetailView: View {
    let result: ScanResult

    var body: some View {
        ScanResultCard(result: result, onSave: {})
            .navigationTitle(result.medicationName)
            .navigationBarTitleDisplayMode(.inline)
    }
}
