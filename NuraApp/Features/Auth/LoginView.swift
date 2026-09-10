//
//  LoginView.swift
//  Nura
//
//  Created by Vannya Ade Gunawan on 31/08/26.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var authViewModel: AuthViewModel

    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Spacer(minLength: 0)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Login")
                            .font(.system(size: 26, weight: .bold))

                        (Text("dengan masuk, anda menyetujui ")
                            .foregroundColor(.gray)
                         + Text("Ketentuan Penggunaan")
                            .foregroundColor(.gray)
                            .fontWeight(.semibold))
                            .font(.system(size: 13))
                    }
                    .padding(.top, 12)

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Email")
                            .font(.system(size: 13, weight: .medium))

                        ZStack(alignment: .leading) {
                            if email.isEmpty {
                                Text("xxxxxxxxxx@gmail.com")
                                    .foregroundColor(.gray)
                            }
                            TextField("", text: $email)
                                .tint(.gray)
                                .foregroundStyle(.black)
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress)
                        }
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

                    Button {
                        Task {
                            await authViewModel.login(email: email, password: password)
                        }
                    } label: {
                        Group {
                            if authViewModel.isLoading {
                                ProgressView().tint(.white)
                            } else {
                                Text("Login")
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

                    HStack(spacing: 4) {
                        Spacer()
                        Text("Belum punya akun?")
                            .foregroundColor(.gray)
                        NavigationLink {
                            RegisterView(authViewModel: authViewModel)
                        } label: {
                            Text("Masuk")
                                .foregroundColor(Color("PrimaryBlue"))
                                .fontWeight(.semibold)
                        }
                        Spacer()
                    }
                    .font(.system(size: 13))

                    dividerWithText("or")

                    socialButtons

                    (Text("Untuk Informasi Lebih Lanjut, Lihat ")
                        .foregroundColor(.black)
                     + Text("Kebijakan Privasi")
                        .foregroundColor(.black)
                        .fontWeight(.semibold))
                        .font(.system(size: 11))
                    
                    Spacer(minLength: 8)
                    
                }
                .padding(.horizontal, 20)
                .frame(minHeight: geometry.size.height)
            }
        }
        
    }

    private var socialButtons: some View {
        VStack(spacing: 12) {
            Button {
                // TODO: hubungkan ke Sign in with Google
            } label: {
                HStack {
                    Image(.google)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                    Text("Sign In with Google")
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }

            Button {
                // TODO: hubungkan ke Sign in with Facebook
            } label: {
                HStack {
                    Image(.facebook)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                    Text("Sign In with Facebook")
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
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
        LoginView(authViewModel: AuthViewModel())
    }
}
