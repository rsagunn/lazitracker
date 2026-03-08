//
//  mainView.swift
//  laziness-tracker
//
//  Created by Reilan Sagun on 2026-03-05.
//

import SwiftUI

struct mainView: View {
    let name: String
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some View {
        VStack(spacing: 16) {
            Text("Welcome, \(name)!")
                .font(.largeTitle.bold())

            Text("This is your main view.")
                .foregroundStyle(.secondary)

            Button("Restart app") {
                hasCompletedOnboarding = false
            }
            .padding(.top, 8)
        }
    }
}

#Preview {
    mainView(name: "Preview")
}
