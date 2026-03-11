//
//  settingsView.swift
//  laziness-tracker
//
//  Created by Reilan Sagun on 2026-03-09.
//

import SwiftUI

struct settingsView: View {
    var body: some View {
        NavigationStack {
            Form {
                Section("About") { // about section
                    LabeledContent("Version", value: appVersionString) // grabs version from info.plist
                    LabeledContent("Build", value: appBuildString) // build number from info.plist
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
}

#Preview {
    settingsView()
}
