//
//  OnboardingView.swift
//  laziness-tracker
//
//  Created by Reilan Sagun on 2026-03-03.
//

import SwiftUI

struct OnboardingPage: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subtitle: String
    let imageName: String?
}

struct OnboardingView: View {
    @Binding var name: String // connects to $name in FinalWelcomeView
    var onFinished: () -> Void = {}
    
    @State private var currentPage = 0

    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                Group {
                    WelcomeView( // uses buttons inside that view
                        onNext: {
                            currentPage = 1
                        },
                        onSkip: {
                            // jump to end
                            currentPage = 2
                        }
                    )
                    .tag(0)
                    .padding()

                    WelcomeDescView(
                        onNext: {
                            currentPage = 2
                        }
                    )
                    .tag(1)
                    .padding()

                    LastWelcomeView(
                        name: $name,
                        onGetStarted: {
                            onFinished()
                        }
                    )
                    .tag(2)
                    .padding()
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always)) // gives navigation dots on bottom
            .animation(.easeInOut, value: currentPage) // more pleasent transition
        }
    }
}

#Preview {
    OnboardingView(name: .constant("67"), onFinished: {}) // let name be 67
}

