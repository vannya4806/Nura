//
//  ArticleDetailView.swift
//  Nura
//
//  Created by Vannya Ade Gunawan on 03/09/26.
//

import SwiftUI

struct ArticleDetailView: View {
    let article: Article

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {

                // MARK: Hero Image
                heroImage

                VStack(alignment: .leading, spacing: 16) {

                    // MARK: Category
                    Text(article.category)
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 9)
                        .padding(.vertical, 5)
                        .background(categoryColor)
                        .clipShape(Capsule())

                    // MARK: Title
                    Text(article.title)
                        .font(.system(size: 23, weight: .bold))
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)

                    // MARK: Author
                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 28, height: 28)
                            .overlay {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }

                        VStack(alignment: .leading, spacing: 2) {
                            Text(article.author ?? "Nura")
                                .font(.system(size: 10, weight: .semibold))

                            Text(article.publishedAt.formatted(
                                .dateTime
                                    .day()
                                    .month(.wide)
                                    .year()
                            ))
                            .font(.system(size: 9))
                            .foregroundColor(.secondary)
                        }
                    }

                    Divider()

                    // MARK: Content
                    Text(article.content)
                        .font(.system(size: 13))
                        .lineSpacing(5)
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(16)
            }
        }
        .background(Color(.systemGroupedBackground))
        .overlay(alignment: .topLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
                    .frame(width: 34, height: 34)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
            }
            .padding(.top, 10)
            .padding(.leading, 16)
        }
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - Hero

    private var heroImage: some View {
        Group {
            if let imageUrl = article.imageUrl,
               let url = URL(string: imageUrl) {

                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()

                    default:
                        heroPlaceholder
                    }
                }

            } else {
                heroPlaceholder
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 240)
        .clipped()
    }

    private var heroPlaceholder: some View {
        ZStack {
            Color.gray.opacity(0.15)

            Image(systemName: "newspaper.fill")
                .font(.system(size: 45))
                .foregroundColor(.gray)
        }
    }

    private var categoryColor: Color {
        if article.category.lowercased().contains("makanan") {
            return Color("PrimaryBlue")
        }

        return Color.green
    }
}
