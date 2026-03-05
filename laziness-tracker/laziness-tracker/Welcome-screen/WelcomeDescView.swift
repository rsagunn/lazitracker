//
//  WelcomeDescView.swift
//  laziness-tracker
//
//  Created by Reilan Sagun on 2026-02-25.
//

import SwiftUI

struct WelcomeDescView: View {
    var onNext: (() -> Void)? = nil
    
    var body: some View {
        ZStack {

            VStack(spacing: 24) {
                // Icon with subtle background and animation
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial) // make the bg of circle transparent
                        .frame(width: 140, height: 140) // circle size

                    Image(systemName: "clock.badge.checkmark")
                        .font(.system(size: 64, weight: .semibold))
                }

                VStack(spacing: 8) {
                    Text("Stay Consistent")
                        .foregroundStyle(.primary)
                        .font(.system(.largeTitle, design: .rounded).bold())
                        .multilineTextAlignment(.center)

                    Text("Create habits, check them off daily, and see your streaks grow. Progress made simple.")
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
    WelcomeDescView()
}

