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
        filteredHistory.filter { $0.scannedAt > Calendar.current.date(byAdding: .day, value: -7, to: Date())! }
    }
    
    var last30Days: [ScanResult] {
        filteredHistory.filter {
            $0.scannedAt <= Calendar.current.date(byAdding: .day, value: -7, to: Date())! &&
            $0.scannedAt > Calendar.current.date(byAdding: .day, value: -30, to: Date())!
        }
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else if filteredHistory.isEmpty {
                emptyView
            } else {
                List {
                    if !last7Days.isEmpty {
                        Section("Previous 7 Days") {
                            ForEach(last7Days) { item in
                                NavigationLink(destination: ScanDetailView(result: item)) {
                                    HistoryRow(result: item)
                                }
                            }
                        }
                    }
                    if !last30Days.isEmpty {
                        Section("Previous 30 Days") {
                            ForEach(last30Days) { item in
                                NavigationLink(destination: ScanDetailView(result: item)) {
                                    HistoryRow(result: item)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Riwayat")
        .searchable(text: $searchText, prompt: "Search for medication...")
        .task {
            await viewModel.loadHistory(userId: userId)
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

struct HistoryRow: View {
    let result: ScanResult
    
    var isSafe: Bool {
        result.riskStatus.lowercased().contains("aman") && !result.riskStatus.lowercased().contains("tidak")
    }
    
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 50, height: 50)
                .overlay(Image(systemName: "pills.fill").foregroundColor(.gray))
            
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
}

struct ScanDetailView: View {
    let result: ScanResult
    
    var body: some View {
        ScanResultCard(result: result, onSave: {})
            .navigationTitle(result.medicationName)
            .navigationBarTitleDisplayMode(.inline)
    }
}
