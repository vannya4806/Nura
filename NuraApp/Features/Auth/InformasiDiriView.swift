//
//  InformasiDiriView.swift
//  Nura
//
//  Created by Vannya Ade Gunawan on 03/09/26.
//


import SwiftUI

struct InformasiDiriView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = InformasiDiriViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                Text("Informasi Diri")
                    .font(.system(size: 18, weight: .semibold))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 8)

                // MARK: - Kondisi Tubuh
                sectionTitle("Kondisi Tubuh")

                HStack(spacing: 12) {
                    labeledField("Tinggi Badan", placeholder: "xxx cm", text: $viewModel.heightText, keyboard: .numberPad)
                    labeledField("Berat Badan", placeholder: "xxx kg", text: $viewModel.weightText, keyboard: .numberPad)
                }

                HStack(spacing: 12) {
                    labeledField("Usia", placeholder: "xxx tahun", text: $viewModel.ageText, keyboard: .numberPad)

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Gender").font(.system(size: 12)).foregroundColor(.black)
                        Menu {
                            Button("Pria") { viewModel.gender = "Pria" }
                            Button("Wanita") { viewModel.gender = "Wanita" }
                        } label: {
                            HStack {
                                Text(viewModel.gender.isEmpty ? "Pria/Wanita" : viewModel.gender)
                                    .foregroundColor(viewModel.gender.isEmpty ? .gray : .black)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 11))
                                    .foregroundColor(.gray)
                            }
                            .font(.system(size: 14))
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }

                // MARK: - Informasi Diri (Obat yang sedang dikonsumsi)
                sectionTitle("Informasi Diri")
                Text("Obat yang Sedang Dikonsumsi")
                    .font(.system(size: 13, weight: .medium))

                ForEach(viewModel.diseases.indices, id: \.self) { index in
                    HStack {
                        TextField("Jenis Obat", text: $viewModel.diseases[index])
                            .padding(10)
                    }
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }

                Button {
                    viewModel.addDiseaseField()
                } label: {
                    Text("+ Add On")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.black)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray6))
                        .cornerRadius(20)
                }

                // MARK: - Alergi Obat
                sectionTitle("Alergi Obat")
                TextField("Jenis alergi yang dimiliki", text: $viewModel.allergy)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)

                // MARK: - Catatan Tambahan
                Text("Catatan Tambahan")
                    .font(.system(size: 13, weight: .medium))

                TextEditor(text: $viewModel.additionalNotes)
                    .scrollContentBackground(.hidden)
                    .font(.system(size: 13))
                    .padding(6)
                    .frame(height: 90)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .overlay(
                        Group {
                            if viewModel.additionalNotes.isEmpty {
                                Text("Kondisi tubuh yang perlu dimengerti oleh kami")
                                    .font(.system(size: 13))
                                    .foregroundColor(Color(.placeholderText))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 14)
                                    .allowsHitTesting(false)
                            }
                        },
                        alignment: .topLeading
                    )
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.system(size: 12))
                        .foregroundColor(.red)
                }

                // MARK: - Tombol Simpan -> menyelesaikan setup profil -> baru masuk ke app
                Button {
                    Task {
                        let success = await viewModel.save()
                        if success {
                            authViewModel.completeProfileSetup()
                        }
                    }
                } label: {
                    Group {
                        if viewModel.isLoading {
                            ProgressView().tint(.white)
                        } else {
                            Text("Simpan")
                                .font(.system(size: 16, weight: .semibold))
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color("PrimaryBlue"))
                    .cornerRadius(12)
                }
                .disabled(viewModel.isLoading || !viewModel.isValid)
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 20)
        }
        .scrollDismissesKeyboard(.interactively)
    }

    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 15, weight: .semibold))
    }

    private func labeledField(_ label: String, placeholder: String, text: Binding<String>, keyboard: UIKeyboardType) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label).font(.system(size: 12)).foregroundColor(.black)
            TextField(placeholder, text: text)
                .keyboardType(keyboard)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    InformasiDiriView(authViewModel: AuthViewModel())
}
