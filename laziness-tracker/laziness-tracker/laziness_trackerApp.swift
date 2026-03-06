//
//  laziness_trackerApp.swift
//  laziness-tracker
//
//  Created by Reilan Sagun on 2026-02-11.
//

import SwiftUI

@main
struct laziness_trackerApp: App {
    @State private var name: String = "" // stores name
    @State private var isOnboarded: Bool = false

    var body: some Scene {
        WindowGroup {
            if isOnboarded {
                mainView(name: name)
            } else {
                OnboardingView(
                    name: $name,
                    onFinished: {
                        isOnboarded = true 
                    }
                )
            }
        }
    }
}
