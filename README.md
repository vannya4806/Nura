# Nura

Nura adalah aplikasi iOS (SwiftUI) untuk membantu pengguna melakukan scan kulit dengan AI, mencatat jadwal & pengingat obat/perawatan, membaca artikel edukasi, serta menyimpan riwayat dan profil pengguna. Backend menggunakan **Firebase** (Authentication, Firestore, Storage).

## ✨ Fitur Utama

- **Onboarding** — perkenalan alur aplikasi untuk pengguna baru
- **Autentikasi** — Register, Login, dan pengisian data diri (`Auth/`)
- **Home** — dashboard utama pengguna
- **AI Scan** — pemindaian kulit/wajah berbasis AI (`AIScan/`)
- **Calendar** — jadwal & pengingat obat/perawatan (`Calendar/`, `AddMedicationView`)
- **Articles** — daftar & detail artikel edukasi (`Articles/`)
- **History** — riwayat hasil scan/aktivitas pengguna
- **Profile** — profil, edit profil, notifikasi, privasi, bantuan, dan tentang aplikasi

## 🧱 Tech Stack

| Komponen | Teknologi |
|---|---|
| UI | SwiftUI |
| Bahasa | Swift 5 |
| Minimum iOS | iOS 26.5 |
| Backend | Firebase (Auth, Firestore, Storage, App Check, Analytics) |
| Package Manager | Swift Package Manager (SPM) |
| Bundle ID | `vannya.ada.academy.NuraApp` |

### Dependencies (SPM — otomatis ter-resolve oleh Xcode)
- firebase-ios-sdk
- app-check
- googleappmeasurement
- googledatatransport
- googleutilities
- google-ads-on-device-conversion-ios-sdk
- grpc-binary, abseil-cpp-binary, leveldb, nanopb, promises, gtm-session-fetcher, interop-ios-for-google-sdks

## 📁 Struktur Folder

```
NuraApp/
├── App/                  
├── Components/           
├── Features/
│   ├── Onboarding/
│   ├── Auth/
│   ├── Home/
│   ├── AIScan/
│   ├── Calendar/
│   ├── Articles/
│   ├── History/
│   ├── Profile/
│   └── Main/             
├── Models/
├── Services/             
├── Utils/
├── Resources/
│   ├── Assets.xcassets
│   └── GoogleService-Info.plist
├── NuraAppApp.swift     
└── ContentView.swift
```

## ✅ Yang Perlu Disiapkan Sebelum Menjalankan

1. **Mac** dengan **Xcode** terinstal (disarankan versi terbaru dari App Store — gratis).
2. **Apple ID biasa** (bukan Apple Developer Program berbayar) — cukup akun iCloud/Apple ID gratis.
3. **iPhone fisik** + **kabel USB/USB‑C/Lightning** untuk sambung ke Mac.
4. File `GoogleService-Info.plist` sudah tersedia di `Resources/` (sudah ada di dalam project ini), jadi Firebase langsung siap dipakai tanpa setup tambahan.
5. Koneksi internet aktif (dipakai Xcode untuk resolve package SPM Firebase saat pertama kali membuka project).

## 🚀 Cara Menjalankan ke iPhone via Kabel

### 1. Buka Project
- Ekstrak/clone folder project ini.
- Buka file **`NuraApp.xcodeproj`** dengan Xcode (double click, atau File → Open).
- Tunggu Xcode selesai "Resolving Package Graph" (proses download dependency Firebase, butuh internet, bisa beberapa menit di percobaan pertama).

### 2. Colokkan iPhone ke Mac
- Sambungkan iPhone ke Mac pakai kabel.
- Di iPhone, jika muncul pop-up **"Trust This Computer?"** → tap **Trust**, lalu masukkan passcode iPhone.
- Di Xcode, buka **Window → Devices and Simulators** untuk pastikan iPhone terdeteksi (opsional, sekadar cek koneksi).

### 3. Aktifkan Developer Mode di iPhone (khusus iOS 16+)
- Setelah install pertama nanti biasanya iPhone akan minta ini, tapi bisa juga diaktifkan manual duluan:
- **Settings → Privacy & Security → Developer Mode** → aktifkan → iPhone akan restart → konfirmasi lagi setelah restart.

### 4. Set Akun Apple ID Gratis di Xcode
- Buka **Xcode → Settings (Preferences) → Accounts**.
- Klik tombol **+** → **Apple ID** → login pakai Apple ID biasa (gratis, tidak perlu enroll Developer Program).

### 5. Atur Signing & Team di Project
- Klik project **NuraApp** di navigator kiri → pilih **target NuraApp** → tab **Signing & Capabilities**.
- Centang **Automatically manage signing**.
- Di dropdown **Team**, pilih akun Apple ID yang baru ditambahkan (akan muncul sebagai *"Nama Kamu (Personal Team)"*).
- Jika muncul error **"Bundle identifier is already in use"**, ubah `PRODUCT_BUNDLE_IDENTIFIER` (misalnya `vannya.ada.academy.NuraApp` → tambahkan sufiks unik seperti `.dev` atau nama kamu) karena akun gratis butuh Bundle ID yang unik secara global.

### 6. Pilih iPhone sebagai Target Device
- Di bagian atas Xcode (sebelah tombol Run ▶️), klik dropdown device.
- Pilih nama iPhone kamu di bawah bagian **"iOS Device"** (bukan Simulator).

### 7. Run
- Tekan tombol **▶️ Run** (atau `Cmd + R`).
- Xcode akan build lalu install app ke iPhone.

### 8. Percaya Developer Certificate di iPhone (hanya sekali)
Setelah install pertama biasanya muncul pesan *"Untrusted Developer"* saat buka app:
- Di iPhone: **Settings → General → VPN & Device Management** (nama menu bisa berbeda: *"Device Management"*).
- Pilih profil developer (nama Apple ID kamu) → tap **Trust "..."** → confirm.
- Buka lagi aplikasi Nura dari home screen.

### 9. Jalankan Ulang Setelah 7 Hari (jika perlu)
- Dengan akun gratis, app di iPhone akan otomatis stop berjalan setelah **7 hari**.
- Solusinya tinggal colok iPhone ke Mac lagi dan tekan **Run** di Xcode — gratis, tidak ada batas berapa kali.
