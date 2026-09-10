//
//  RegisterView.swift
//  Nura
//
//  Created by Vannya Ade Gunawan on 31/08/26.
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject var authViewModel: AuthViewModel

    @State private var email: String = ""
    @State private var password: String = ""
    private let name: String = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                Spacer(minLength: 0)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Masuk")
                        .font(.system(size: 26, weight: .bold))

                    HStack(spacing: 4) {
                        Text("dengan masuk, anda menyetujui ")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                        Text("Ketentuan Penggunaan")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top, 12)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Email")
                        .font(.system(size: 13, weight: .medium))
                    TextField("xxxxxxxxxx@gmail.com", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("Password")
                        .font(.system(size: 13, weight: .medium))
                    SecureField("••••••••", text: $password)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }

                if let errorMessage = authViewModel.errorMessage {
                    Text(errorMessage)
                        .font(.system(size: 12))
                        .foregroundColor(.red)
                }

                // MARK: - Tombol Masuk (register) — WAJIB lanjut ke InformasiDiriView setelah ini
                Button {
                    Task {
                        await authViewModel.register(email: email, password: password, name: name)
                    }
                } label: {
                    Group {
                        if authViewModel.isLoading {
                            ProgressView().tint(.white)
                        } else {
                            Text("Masuk")
                                .font(.system(size: 16, weight: .semibold))
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color("PrimaryBlue"))
                    .cornerRadius(12)
                }
                .disabled(authViewModel.isLoading || email.isEmpty || password.isEmpty)

                // "sudah punya akun? Login" -> kembali ke LoginView
                HStack {
                    Spacer()
                    Text("sudah punya akun? ")
                        .foregroundColor(.gray)
                    + Text("Login")
                        .foregroundColor(Color("PrimaryBlue"))
                        .fontWeight(.semibold)
                    Spacer()
                }
                .font(.system(size: 13))
                .onTapGesture {
                    dismiss()
                }

                dividerWithText("or")

                socialButtons

                Spacer(minLength: 8)

                (Text("Untuk Informasi Lebih Lanjut, Lihat ")
                    .foregroundColor(.black)
                 + Text("Kebijakan Privasi")
                    .foregroundColor(.black)
                    .fontWeight(.semibold))
                .font(.system(size: 11))
            }
            .padding(.horizontal, 20)
        }
    }

    @Environment(\.dismiss) private var dismiss

    private var socialButtons: some View {
        VStack(spacing: 12) {
            Button {
                // TODO: hubungkan ke Sign in with Google
            } label: {
                HStack {
                    Image("googlelogo")
                    Text("Sign In with Google")
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }

            Button {
                // TODO: hubungkan ke Sign in with Facebook
            } label: {
                HStack {
                    Image("facebooklogo")
                    Text("Sign In with Facebook")
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color(red: 0.26, green: 0.40, blue: 0.70))
                .cornerRadius(12)
            }
        }
    }

    private func dividerWithText(_ text: String) -> some View {
        HStack {
            Rectangle().frame(height: 1).foregroundColor(Color(.systemGray4))
            Text(text).font(.system(size: 12)).foregroundColor(.gray)
            Rectangle().frame(height: 1).foregroundColor(Color(.systemGray4))
        }
    }
}

#Preview {
    NavigationStack {
        RegisterView(authViewModel: AuthViewModel())
    }
}
