//
//  PrivacyView.swift
//  Nura
//
//  Created by Vannya Ade Gunawan on 03/09/26.
//

import SwiftUI

struct PrivacyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                Text("Privasi")
                    .font(.system(size: 20, weight: .bold))

                Text("""
Nura adalah aplikasi pribadi kami. Kami berkomitmen untuk menjaga keamanan data pribadi dan kesehatan Anda.

Informasi yang Kami Kumpulkan

Data yang mungkin dikumpulkan:
• Nama
• Alamat email
• Foto profil
• Tinggi badan dan berat badan
• Usia
• Gender
• Obat yang sedang dikonsumsi
• Alergi obat
• Catatan tambahan mengenai kondisi tubuh Anda

Penggunaan Informasi

Data yang Anda berikan digunakan untuk:
• Analisis keamanan obat
• Memberikan informasi terkait obat
• Membantu mengatur jadwal konsumsi obat
• Memberikan rekomendasi yang lebih personal

Kami tidak menjual data pribadi Anda kepada pihak ketiga.

Hubungi Kami

Jika Anda memiliki pertanyaan mengenai kebijakan privasi, silakan hubungi kami melalui email support.
""")
                .font(.system(size: 11))
                .lineSpacing(4)
            }
            .padding(16)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Privasi")
        .navigationBarTitleDisplayMode(.inline)
    }
}
