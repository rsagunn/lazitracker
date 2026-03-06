//
//  mainView.swift
//  laziness-tracker
//
//  Created by Reilan Sagun on 2026-03-05.
//

import SwiftUI

struct mainView: View {
    let name: String
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Welcome, \(name)!")
                .font(.largeTitle.bold())
            
            Text("This is your main view.")
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    mainView(name: "Preview")
}
