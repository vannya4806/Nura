//
//  ArticleListView.swift
//  Nura
//
//  Created by Vannya Ade Gunawan on 31/08/26.
//

import SwiftUI

struct ArticleListView: View {
    @StateObject private var viewModel = ArticleViewModel()

    @Environment(\.dismiss) private var dismiss

    @State private var selectedCategory = "Semua"
    @State private var searchText = ""

    private let categories = [
        "Semua",
        "antar Obat",
        "Obat dan Makanan"
    ]

    var filteredArticles: [Article] {
        var result = viewModel.articles

        if selectedCategory != "Semua" {
            result = result.filter {
                $0.category.lowercased() == selectedCategory.lowercased()
            }
        }

        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText)
            }
        }

        return result
    }

    var body: some View {
        VStack(spacing: 0) {

            // MARK: Header
            header

            // MARK: Category
            categoryFilter

            // MARK: Articles
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxHeight: .infinity)

            } else if let error = viewModel.errorMessage {
                VStack(spacing: 10) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 30))

                    Text(error)
                        .font(.system(size: 12))
                        .multilineTextAlignment(.center)

                    Button("Coba Lagi") {
                        Task {
                            await viewModel.loadArticles()
                        }
                    }
                    .foregroundColor(Color("PrimaryBlue"))
                }
                .padding()
                .frame(maxHeight: .infinity)

            } else if filteredArticles.isEmpty {
                emptyState

            } else {
                articleList
            }

            // MARK: Search
            searchBar
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarBackButtonHidden(true)
        .task {
            await viewModel.loadArticles()
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
                    .frame(width: 32, height: 32)
                    .background(Color.white)
                    .clipShape(Circle())
            }

            Spacer()

            Text("Artikel Terkini")
                .font(.system(size: 15, weight: .semibold))

            Spacer()

            Image(systemName: "line.3.horizontal.decrease")
                .font(.system(size: 15))
                .frame(width: 32, height: 32)
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 10)
        .background(Color(.systemGroupedBackground))
    }

    // MARK: - Category Filter

    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(categories, id: \.self) { category in
                    Button {
                        selectedCategory = category
                    } label: {
                        Text(category)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(
                                selectedCategory == category
                                ? .white
                                : .primary
                            )
                            .padding(.horizontal, 13)
                            .padding(.vertical, 8)
                            .background(
                                selectedCategory == category
                                ? Color("PrimaryBlue")
                                : Color.white
                            )
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 10)
        }
    }

    // MARK: - Article List

    private var articleList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 8) {
                ForEach(filteredArticles) { article in
                    NavigationLink {
                        ArticleDetailView(article: article)
                    } label: {
                        ArticleCardView(article: article)
                    }

                    Divider()
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 5)
            .padding(.bottom, 10)
        }
    }

    // MARK: - Search

    private var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField(
                "Search for Artikel...",
                text: $searchText
            )
            .font(.system(size: 12))

            Image(systemName: "mic.fill")
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 12)
        .frame(height: 42)
        .background(Color.white)
        .clipShape(Capsule())
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }

    private var emptyState: some View {
        VStack(spacing: 10) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 35))
                .foregroundColor(.gray)

            Text("Artikel tidak ditemukan")
                .font(.system(size: 13, weight: .semibold))

            Text("Coba gunakan kategori atau kata kunci lain.")
                .font(.system(size: 11))
                .foregroundColor(.secondary)
        }
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    NavigationStack {
        ArticleListView()
    }
}
