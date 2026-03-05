//
//  LastWelcomeView.swift
//  laziness-tracker
//
//  Created by Reilan Sagun on 2026-03-02.
//

import SwiftUI

struct LastWelcomeView: View {
    @State private var name: String = "" // name
    
    private var isNameValid: Bool { // checks if name is empty
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty // if name not empty return true
    }
    
    var body: some View {
        ZStack {

            VStack(spacing: 24) {
                // Icon with subtle background and animation
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial) // make the bg of circle transparent
                        .frame(width: 140, height: 140) // circle size

                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 64, weight: .semibold))
                }

                VStack(spacing: 8) {
                    Text("Ready to Grow?")
                        .foregroundStyle(.primary)
                        .font(.system(.largeTitle, design: .rounded).bold())
                        .multilineTextAlignment(.center)

                    Text("Track your habits, stay motivated, and watch your progress build over time.")
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 8)
                }
                .padding(.horizontal)
                
                TextField("Enter your name", text: $name)
                    .padding()
                       .background(.ultraThinMaterial)
                       .background(
                           RoundedRectangle(cornerRadius: 20)
                               .fill(.white.opacity(0.1))
                       )
                       .clipShape(RoundedRectangle(cornerRadius: 20))
                       .overlay(
                           RoundedRectangle(cornerRadius: 20)
                               .stroke(.white.opacity(0.25), lineWidth: 1)
                       )
                       .shadow(color: .black.opacity(0.2), radius: 15, y: 5)
                    .padding(.horizontal)
                
                Button(action: {
                    
                }) {
                    Label("Get started", systemImage: "arrow.right.circle.fill")
                        .font(.headline)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(.ultraThinMaterial, in: Capsule())
                }
                .disabled(!isNameValid) // if name is empty disable button
                .opacity(isNameValid ? 1.0 : 0.5) // make btn transparent if name is empty
            }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.06), radius: 20, x: 0, y: 10)
            )
            .padding(.horizontal)
    }
}

#Preview {
    LastWelcomeView()
}
