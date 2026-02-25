//
//  ContentView.swift
//  laziness-tracker
//
//  Created by Reilan Sagun on 2026-02-11.
//
//User gets welcomed to app and prompts a input to input name. This name shall be saved accrosed the app globaly.

import SwiftUI

let backgroundGradient = LinearGradient(
    colors: [Color.purple, Color.black, Color.blue],
    startPoint: .top, endPoint: .bottom)

struct WelcomeView: View {
    var body: some View {
        ZStack {
            // Background gradient
            backgroundGradient
                .ignoresSafeArea() //allow gradient to go under iphone notches and crevices

            VStack(spacing: 16) {
                Text("Welcome to Lazi-Tracker!")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white)

                Button(action: {
                    
                }) {
                    Label("Next", systemImage: "arrow.right.circle.fill")
                        .font(.headline)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(.ultraThinMaterial, in: Capsule())
                }
            }
            .padding()
        }
    }
}

#Preview {
    WelcomeView()
}
