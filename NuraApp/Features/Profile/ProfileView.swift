//
//  ProfileView.swift
//  Nura
//
//  Created by Vannya Ade Gunawan on 31/08/26.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()

    let userId: String

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {

                profileHeader

                menuSection
                    .padding(.top, 25)

                signOutButton
                    .padding(.top, 35)
                    .padding(.bottom, 30)
            }
            .padding(.horizontal, 16)
        }
        .background(Color(.systemGroupedBackground))
        .task {
            await viewModel.loadUser(userId: userId)
        }
    }

    // MARK: - Header

    private var profileHeader: some View {
        VStack(spacing: 10) {

            if let photoUrl = viewModel.user?.photoUrl,
               let url = URL(string: photoUrl) {

                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()

                    default:
                        profilePlaceholder
                    }
                }
                .frame(width: 90, height: 90)
                .clipShape(Circle())

            } else {
                profilePlaceholder
            }

            Text(viewModel.user?.name ?? "Loading...")
                .font(.system(size: 16, weight: .bold))

            Text(viewModel.user?.email ?? "")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
        }
        .padding(.top, 35)
    }

    private var profilePlaceholder: some View {
        Circle()
            .fill(Color.gray.opacity(0.2))
            .frame(width: 90, height: 90)
            .overlay {
                Image(systemName: "person.fill")
                    .font(.system(size: 35))
                    .foregroundColor(.gray)
            }
    }

    // MARK: - Menu

    private var menuSection: some View {
        VStack(spacing: 0) {

            NavigationLink {
                if let user = viewModel.user {
                    EditProfileView(
                        user: user,
                        onSave: { updatedUser in
                            Task {
                                await viewModel.updateUser(updatedUser)
                            }
                        }
                    )
                }
            } label: {
                menuItem(title: "Informasi Diri")
            }

            NavigationLink {
                PrivacyView()
            } label: {
                menuItem(title: "Privasi")
            }

            NavigationLink {
                NotificationView()
            } label: {
                menuItem(title: "Notifikasi")
            }

            NavigationLink {
                HelpSupportView()
            } label: {
                menuItem(title: "Bantuan & Support")
            }

            NavigationLink {
                AboutView()
            } label: {
                menuItem(title: "Tentang")
            }
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private func menuItem(title: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 14)
        .frame(height: 45)
    }

    // MARK: - Sign Out

    private var signOutButton: some View {
        Button {
            viewModel.logout()
        } label: {
            Text("Sign Out")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(Color.red)
                .clipShape(Capsule())
        }
    }
}
