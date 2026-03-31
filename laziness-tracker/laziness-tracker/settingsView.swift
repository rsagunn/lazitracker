//
//  settingsView.swift
//  laziness-tracker
//
//  Created by Reilan Sagun on 2026-03-09.
//

import SwiftUI

struct settingsView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false // when false app shows onboarding again
    @State private var isAlertShown = false
    @AppStorage("userName") private var name: String = ""
    var body: some View {
        NavigationStack {
            Form {
                Section("About") { // about section
                    LabeledContent("Version", value: appVersionString) // grabs version from info.plist
                    LabeledContent("Build", value: appBuildString) // build number from info.plist
                }
                Section("App") {
                    LabeledContent {
                                    Button("") {
                                        isAlertShown = true // show onboarding again
                                    }
                                    .alert("Are you sure you want to reset the app?", isPresented: $isAlertShown) {
                                        Button("Yes", role: .destructive) { // .destructive shows btn means reset
                                            hasCompletedOnboarding = false
                                            resetApp()
                                        }
                                    }
                                    } label: {
                                    // the label (description)
                                    Text("Reset")
                                            .foregroundStyle(.red)
                                }
                }
            }
            .navigationTitle("Settings")
        }
    }

    private var appVersionString: String { 
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "—" // if no version show -
    }

    private var appBuildString: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "—" // if no build number show -
    }
    func resetApp() {
        name = "" // clears the saved name
        // clear all saved habits
        UserDefaults.standard.removeObject(forKey: "habitTracker.habits.v1")
    }
}

#Preview {
    settingsView()
}
