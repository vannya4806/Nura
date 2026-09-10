import SwiftUI

struct HelpSupportView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Bantuan & Support")
                    .font(.title3).bold()

                SectionView(title: "Frequently Ask Question (FAQ)", content: "\nApa itu NURA?\nNURA adalah asisten kesehatan digital yang membantu Anda memahami dan mengelola penggunaan obat.\n\nBagaimana cara kerja AI di NURA?\nAI melakukan OCR pada label obat, memproses teks, dan mengklasifikasikan obat untuk menampilkan informasi yang relevan.\n\nApakah data saya aman?\nKami berkomitmen menjaga privasi. Lihat pengaturan Privasi untuk detail lebih lanjut.")

                SectionView(title: "Hubungi Kami", content: "\nEmail: support@nura.app\nInstagram: @nura.app\nWebsite: https://nura.app\nJam Operasional: Senin-Jumat (09.00-17.00 WIB)")
            }
            .padding(16)
        }
        .navigationTitle("Bantuan & Support")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct SectionView: View {
    let title: String
    let content: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            Text(content)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
    }
}

#Preview {
    NavigationStack { HelpSupportView() }
}
