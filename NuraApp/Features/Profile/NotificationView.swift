import SwiftUI

struct NotificationView: View {
    @State private var pillReminderEnabled = true
    @State private var consultNotifEnabled = true
    @State private var articleNotifEnabled = false
    @State private var promoNotifEnabled = false
    @State private var silentModeOverride = false

    var body: some View {
        List {
            Section(header: Text("Kelola notifikasi agar Anda tetap mendapatkan informasi penting sesuai kebutuhan.")) {
                Toggle(isOn: $pillReminderEnabled) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Pengingat Minum Obat").font(.body)
                        Text("Aktifkan pengingat minum obat harian.").font(.caption).foregroundColor(.secondary)
                    }
                }

                Toggle(isOn: $consultNotifEnabled) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Notifikasi Konsultasi").font(.body)
                        Text("Jangan lewatkan jadwal konsultasi atau pesan penting dari tenaga kesehatan.").font(.caption).foregroundColor(.secondary)
                    }
                }

                Toggle(isOn: $articleNotifEnabled) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Artikel Terbaru").font(.body)
                        Text("Dapatkan artikel terbaru seputar kondisi dan obat Anda.").font(.caption).foregroundColor(.secondary)
                    }
                }

                Toggle(isOn: $promoNotifEnabled) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Promo & Informasi Terbaru").font(.body)
                        Text("Informasi produk, fitur baru, dan penawaran spesial.").font(.caption).foregroundColor(.secondary)
                    }
                }

                Toggle(isOn: $silentModeOverride) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Mode Jangan Ganggu").font(.body)
                        Text("Izinkan pengingat penting muncul meskipun perangkat dalam mode senyap.").font(.caption).foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Notifikasi")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { NotificationView() }
}
