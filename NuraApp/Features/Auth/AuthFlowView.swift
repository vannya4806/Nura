//
//  AuthFlowView.swift
//  Nura
//
//  Created by Vannya Ade Gunawan on 03/09/26.
//

import SwiftUI

struct AuthFlowView: View {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        Group {
            if authViewModel.isLoggedIn {
                MainTabView(userId: authViewModel.currentUserId, userName: authViewModel.currentUserName)
            }
            
            else if authViewModel.needsProfileSetup {
                InformasiDiriView(authViewModel: authViewModel)
                
            } else {
                NavigationStack {
                    LoginView(authViewModel: authViewModel)
                }
            }
        }
        .animation(.easeInOut, value: authViewModel.isLoggedIn)
        .animation(.easeInOut, value: authViewModel.needsProfileSetup)
    }
}

#Preview {
    AuthFlowView()
}
