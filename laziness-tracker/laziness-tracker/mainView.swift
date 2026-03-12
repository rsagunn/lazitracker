//
//  mainView.swift
//  laziness-tracker
//
//  Created by Reilan Sagun on 2026-03-05.
//

import SwiftUI

struct mainView: View {
    let name: String // username from onboarding


    var body: some View {
        TimelineView(.atHourBoundaries) { context in // refreshes at each hour
            VStack(alignment: .leading, spacing: 16) {
                Text("\(context.date.timeGreeting), \(name)!")
                    .font(.largeTitle.bold())

                Text("This is your main view.")
                    .foregroundStyle(.secondary)

                .padding(.top, 8)

                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading) 
            .padding()
        }
    }
}

#Preview {
    mainView(name: "Preview")
}
