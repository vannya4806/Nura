//
//  ContentView.swift
//  NuraApp
//

import SwiftUI

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some View {
        if hasCompletedOnboarding {
            AuthFlowView()
        } else {
            OnboardingView()
        }
    }
}

#Preview {
    ContentView()
}
