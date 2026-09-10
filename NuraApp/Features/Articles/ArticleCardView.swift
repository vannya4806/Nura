//
//  ArticleCardView.swift
//  Nura
//
//  Created by Vannya Ade Gunawan on 03/09/26.
//

import SwiftUI

struct ArticleCardView: View {
    let article: Article

    var body: some View {
        HStack(spacing: 12) {

            articleImage

            VStack(alignment: .leading, spacing: 5) {

                Text(article.category)
                    .font(.system(size: 8, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 4)
                    .background(categoryColor)
                    .clipShape(Capsule())

                Text(article.title)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(2)

                HStack(spacing: 3) {
                    Text("read more")
                    Image(systemName: "chevron.right")
                }
                .font(.system(size: 9))
                .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 5)
    }

    private var articleImage: some View {
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
                        placeholder
                    }
                }

            } else {
                placeholder
            }
        }
        .frame(width: 82, height: 64)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var placeholder: some View {
        ZStack {
            Color.gray.opacity(0.15)

            Image(systemName: "newspaper.fill")
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
