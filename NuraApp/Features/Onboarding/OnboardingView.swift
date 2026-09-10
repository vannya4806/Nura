//
//  OnboardingView.swift
//  Nura
//
//  Created by Vannya Ade Gunawan on 31/08/26.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()

    var body: some View {
        VStack(spacing: 0) {

            // MARK: - Halaman onboarding (swipeable)
            TabView(selection: $viewModel.currentPage) {
                ForEach(Array(viewModel.pages.enumerated()), id: \.offset) { index, page in
                    OnboardingPageView(page: page)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: viewModel.currentPage)

            // MARK: - Bottom control area
            if viewModel.isLastPage {
                Button(action: {
                    viewModel.finish()
                }) {
                    Text("Mulai")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color("PrimaryBlue"))
                        .cornerRadius(10000)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 24)
            } else {
                HStack {
                    Button("Skip") {
                        viewModel.skip()
                    }
                    .foregroundColor(Color("PrimaryBlue"))

                    Spacer()

                    PageIndicator(
                        numberOfPages: viewModel.pages.count,
                        currentPage: viewModel.currentPage
                    )

                    Spacer()

                    Button("Next") {
                        viewModel.next()
                    }
                    .foregroundColor(Color("PrimaryBlue"))
                }
                .font(.system(size: 14, weight: .medium))
                .padding(.horizontal, 24)
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
        }
        .background(Color.white.ignoresSafeArea())
    }
}

// MARK: - Satu halaman onboarding
private struct OnboardingPageView: View {
    let page: OnboardingPage

    var body: some View {
        VStack(spacing: 32) {
            Spacer(minLength: 40)
            
            Image(page.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 280)

            VStack(spacing: 12) {
                Text(page.title)
                    .font(.system(size: 20, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)

                Text(page.description)
                    .font(.system(size: 14))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 32)
            }

            Spacer()
        }
        .padding(.top, 24)
    }
}

// MARK: - Dot page indicator (bulat aktif berwarna, sisanya abu-abu muda)
private struct PageIndicator: View {
    let numberOfPages: Int
    let currentPage: Int

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<numberOfPages, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? Color("PrimaryBlue") : Color.gray.opacity(0.3))
                    .frame(width: 6, height: 6)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    OnboardingView()
}
