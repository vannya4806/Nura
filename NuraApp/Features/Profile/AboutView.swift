//
//  AboutView.swift
//  Nura
//
//  Created by Vannya Ade Gunawan on 03/09/26.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                Text("Selamat datang di NURA, aplikasi yang membantu Anda mengelola kesehatan dengan lebih mudah dan terarah.")

                section(
                    title: "Visi",
                    text: "Menjadi asisten kesehatan digital yang terpercaya dalam membantu pengguna memahami, mengelola, dan menggunakan obat dengan lebih aman."
                )

                section(
                    title: "Misi",
                    text: "Menyederhanakan informasi medis, memberikan edukasi yang mudah dipahami, dan membantu pengguna mengelola konsumsi obat."
                )

                section(
                    title: "Versi Aplikasi",
                    text: "Nura v1.0.0"
                )
            }
            .font(.system(size: 11))
            .lineSpacing(4)
            .padding(16)
        }
        .navigationTitle("Tentang")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func section(
        title: String,
        text: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 13, weight: .bold))

            Text(text)
        }
    }
}
