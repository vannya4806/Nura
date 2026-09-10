import SwiftUI

struct AIScanView: View {
    @StateObject private var viewModel = AIScanViewModel()
    @State private var showCamera = false
    @State private var showImagePicker = false
    
    let userId: String
    
    var body: some View {
        VStack {
            switch viewModel.scanState {
            case .idle:
                idleView
            case .scanning:
                scanningView
            case .success:
                if let result = viewModel.result {
                    ScanResultCard(result: result, onSave: {
                        Task {
                            await viewModel.saveToHistory()
                            viewModel.reset()
                        }
                    })
                }
            case .failed(let message):
                failedView(message: message)
            }
        }
        .navigationTitle("NURA")
        .sheet(isPresented: $showCamera) {
            ImagePicker(sourceType: .camera) { image in
                Task { await viewModel.analyze(image: image, userId: userId) }
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: .photoLibrary) { image in
                Task { await viewModel.analyze(image: image, userId: userId) }
            }
        }
    }
    
    private var idleView: some View {
        VStack(spacing: 20) {
            if let image = viewModel.capturedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 350)
                    .cornerRadius(12)
            } else {
                Image(systemName: "camera.viewfinder")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.gray)
                Text("Arahkan kamera ke kemasan obat")
                    .foregroundColor(.gray)
            }
            
            HStack(spacing: 16) {
                Button {
                    showCamera = true
                } label: {
                    Label("Kamera", systemImage: "camera")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button {
                    showImagePicker = true
                } label: {
                    Label("Galeri", systemImage: "photo")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
        }
        .padding()
    }
    
    private var scanningView: some View {
        VStack(spacing: 16) {
            if let image = viewModel.capturedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .cornerRadius(12)
                    .opacity(0.6)
            }
            ProgressView()
            Text("Menganalisis obat...")
                .foregroundColor(.gray)
        }
        .padding()
    }
    
    private func failedView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.orange)
            Text("Analisis Gagal")
                .font(.headline)
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal)
            Button("OK") {
                viewModel.reset()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
        }
    }
}

// MARK: - Result Card (dipakai juga sama HistoryView)
struct ScanResultCard: View {
    let result: ScanResult
    let onSave: () -> Void
    
    var isSafe: Bool {
        result.riskStatus.lowercased().contains("aman") && !result.riskStatus.lowercased().contains("tidak")
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                RiskBadgeView(isSafe: isSafe, text: result.riskStatus)
                
                Text(result.medicationName)
                    .font(.title2)
                    .bold()
                
                Text("Overview")
                    .font(.headline)
                Text(result.overview)
                    .foregroundColor(.secondary)
                
                if !result.drugInteractions.isEmpty {
                    Text("Interaksi dengan obat lain")
                        .font(.headline)
                    ForEach(result.drugInteractions, id: \.drugName) { item in
                        HStack {
                            Text(item.drugName)
                            Spacer()
                            RiskBadgeView(isSafe: item.riskLevel.lowercased() == "aman", text: item.riskLevel)
                        }
                    }
                }
                
                if !result.foodInteractions.isEmpty {
                    Text("Interaksi dengan makanan")
                        .font(.headline)
                    ForEach(result.foodInteractions, id: \.description) { item in
                        Text(item.description)
                            .foregroundColor(.secondary)
                    }
                }
                
                Button(action: onSave) {
                    Text("Simpan ke Riwayat")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}

// MARK: - Badge kecil, dipakai di AIScan & History
struct RiskBadgeView: View {
    let isSafe: Bool
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: isSafe ? "checkmark.circle.fill" : "xmark.circle.fill")
            Text(text)
        }
        .font(.caption)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(isSafe ? Color.green.opacity(0.15) : Color.red.opacity(0.15))
        .foregroundColor(isSafe ? .green : .red)
        .cornerRadius(20)
    }
}

// MARK: - Image Picker (kamera/galeri)
struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType
    var onImagePicked: (UIImage) -> Void
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        init(_ parent: ImagePicker) { self.parent = parent }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.onImagePicked(image)
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}
