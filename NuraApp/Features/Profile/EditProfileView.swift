//
//  EditProfileView.swift
//  Nura
//
//  Created by Vannya Ade Gunawan on 03/09/26.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var user: User

    let onSave: (User) -> Void

    init(
        user: User,
        onSave: @escaping (User) -> Void
    ) {
        _user = State(initialValue: user)
        self.onSave = onSave
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {

                sectionTitle("Kondisi Tubuh")

                HStack(spacing: 10) {
                    inputField(
                        title: "Tinggi Badan",
                        text: Binding(
                            get: { "\(Int(user.height))" },
                            set: {
                                user.height = Double($0) ?? user.height
                            }
                        )
                    )

                    inputField(
                        title: "Berat Badan",
                        text: Binding(
                            get: { "\(Int(user.weight))" },
                            set: {
                                user.weight = Double($0) ?? user.weight
                            }
                        )
                    )
                }

                HStack(spacing: 10) {
                    inputField(
                        title: "Usia",
                        text: Binding(
                            get: { "\(user.age)" },
                            set: {
                                user.age = Int($0) ?? user.age
                            }
                        )
                    )

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Gender")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)

                        Picker("Gender", selection: $user.gender) {
                            Text("Pria").tag("Pria")
                            Text("Wanita").tag("Wanita")
                        }
                        .pickerStyle(.menu)
                        .frame(maxWidth: .infinity)
                        .frame(height: 38)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }

                sectionTitle("Informasi Diri")
                    .padding(.top, 5)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Obat yang Sedang Dikonsumsi")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)

                    TextField(
                        "Nama obat",
                        text: Binding(
                            get: {
                                user.diseases.joined(separator: ", ")
                            },
                            set: {
                                user.diseases = $0
                                    .split(separator: ",")
                                    .map {
                                        $0.trimmingCharacters(
                                            in: .whitespaces
                                        )
                                    }
                            }
                        )
                    )
                    .textFieldStyle(.plain)
                    .padding(.horizontal, 12)
                    .frame(height: 40)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Alergi Obat")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)

                        Spacer()

                        Button("+ Add On") {
                            user.allergies.append("")
                        }
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(Color("PrimaryBlue"))
                    }

                    ForEach(
                        Array(user.allergies.enumerated()),
                        id: \.offset
                    ) { index, allergy in

                        TextField(
                            "Alergi obat",
                            text: Binding(
                                get: {
                                    user.allergies[index]
                                },
                                set: {
                                    user.allergies[index] = $0
                                }
                            )
                        )
                        .textFieldStyle(.plain)
                        .padding(.horizontal, 12)
                        .frame(height: 40)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Catatan Tambahan")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)

                    TextEditor(
                        text: Binding(
                            get: {
                                user.additionalNotes ?? ""
                            },
                            set: {
                                user.additionalNotes = $0
                            }
                        )
                    )
                    .frame(height: 90)
                    .padding(8)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                Button {
                    onSave(user)
                    dismiss()
                } label: {
                    Text("Simpan")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 42)
                        .background(Color("PrimaryBlue"))
                        .clipShape(Capsule())
                }
                .padding(.top, 5)
            }
            .padding(16)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Informasi Diri")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 14, weight: .bold))
    }

    private func inputField(
        title: String,
        text: Binding<String>
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 10))
                .foregroundColor(.secondary)

            TextField(title, text: text)
                .keyboardType(.decimalPad)
                .padding(.horizontal, 10)
                .frame(height: 38)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .frame(maxWidth: .infinity)
    }
}
