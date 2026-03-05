//
//  ContentView.swift
//  laziness-tracker
//
//  Created by Reilan Sagun on 2026-02-11.
//
//User gets welcomed to app and prompts a input to input name. This name shall be saved accrosed the app globaly.

import SwiftUI

struct WelcomeView: View {
    var onNext: (() -> Void)? = nil
    var onSkip: (() -> Void)? = nil
    
    var body: some View {
        ZStack {
            // Top-left Skip button
            VStack {
                HStack {
                    Button("Skip") {
                        onSkip?()
                    }
                    .foregroundStyle(.blue)
                    .buttonStyle(.plain)
                    .padding(12)
                    Spacer()
                }
                Spacer()
            }
            VStack(spacing: 24) {
                // Icon with subtle background and animation
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial) // make the bg of circle transparent
                        .frame(width: 140, height: 140) // circle size

                    Image("head-icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                }

                VStack(spacing: 8) {
                    Text("Welcome to Lazi-Tracker!")
                        .foregroundStyle(.primary)
                        .font(.system(.largeTitle, design: .rounded).bold())
                        .multilineTextAlignment(.center)

                    Text("Made by R.S")
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 8)
                }
                .padding(.horizontal)
                Button(action: {
                    onNext?()
                }) {
                    Label("Next", systemImage: "arrow.right.circle.fill")
                        .font(.headline)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(.ultraThinMaterial, in: Capsule())
                }
            }
            .padding(.horizontal)
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.ultraThinMaterial)
            )
        }
    }
}
#Preview {
    WelcomeView()
}

