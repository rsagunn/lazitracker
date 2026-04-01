//
//  HabitTrackerComponents.swift
//  laziness-tracker
//
//  Created by Reilan Sagun on 2026-3-27.
//

import SwiftUI

struct CardShell<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(16)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(.black.opacity(0.05), lineWidth: 1)
            )
    }
}

struct HabitIconOption: Identifiable, Hashable {
    var id: String { systemImage }
    let systemImage: String
    let label: String
}

let habitIconOptions: [HabitIconOption] = [
    // common icons
    HabitIconOption(systemImage: "figure.walk", label: "Walk"),
    HabitIconOption(systemImage: "figure.run", label: "Run"),
    HabitIconOption(systemImage: "figure.strengthtraining.traditional", label: "Strength"),
    HabitIconOption(systemImage: "figure.yoga", label: "Yoga"),
    HabitIconOption(systemImage: "bicycle", label: "Bike"),
    HabitIconOption(systemImage: "dumbbell.fill", label: "Dumbbell"),
    HabitIconOption(systemImage: "bolt.fill", label: "Bolt"),
    HabitIconOption(systemImage: "flame.fill", label: "Flame"),
    HabitIconOption(systemImage: "heart.fill", label: "Heart"),
    HabitIconOption(systemImage: "leaf.fill", label: "Leaf"),
    HabitIconOption(systemImage: "sun.max.fill", label: "Sun"),
    HabitIconOption(systemImage: "moon.fill", label: "Moon"),
    HabitIconOption(systemImage: "cloud.sun.fill", label: "Weather"),
    HabitIconOption(systemImage: "wind", label: "Wind"),
    HabitIconOption(systemImage: "drop.fill", label: "Water"),
    HabitIconOption(systemImage: "sparkles", label: "Sparkles"),
    HabitIconOption(systemImage: "star.fill", label: "Star"),
    HabitIconOption(systemImage: "target", label: "Target"),
    HabitIconOption(systemImage: "trophy.fill", label: "Trophy"),

    // learning or habits
    HabitIconOption(systemImage: "book.fill", label: "Book"),
    HabitIconOption(systemImage: "graduationcap.fill", label: "Study"),
    HabitIconOption(systemImage: "pencil.and.ruler.fill", label: "Create"),
    HabitIconOption(systemImage: "paintbrush.fill", label: "Paint"),
    HabitIconOption(systemImage: "music.note", label: "Music"),
    HabitIconOption(systemImage: "gamecontroller.fill", label: "Game"),
    HabitIconOption(systemImage: "medal.fill", label: "Medal"),

    // food routine
    HabitIconOption(systemImage: "fork.knife", label: "Food"),
    HabitIconOption(systemImage: "carrot.fill", label: "Carrot"),
    HabitIconOption(systemImage: "leaf.arrow.circlepath", label: "Green"),
    HabitIconOption(systemImage: "bed.double.fill", label: "Sleep"),

    // outdoor
    HabitIconOption(systemImage: "airplane", label: "Travel"),
    HabitIconOption(systemImage: "map.fill", label: "Map"),
    HabitIconOption(systemImage: "mountain.2.fill", label: "Mountain"),
    HabitIconOption(systemImage: "figure.hiking", label: "Hike"),
    HabitIconOption(systemImage: "tornado", label: "Storm"),
    HabitIconOption(systemImage: "hare.fill", label: "Fast"),

    // other
    HabitIconOption(systemImage: "calendar", label: "Calendar"),
    HabitIconOption(systemImage: "timer", label: "Timer"),
    HabitIconOption(systemImage: "timer.circle", label: "Timer"),
    HabitIconOption(systemImage: "alarm.fill", label: "Alarm"),
    HabitIconOption(systemImage: "brain.head.profile", label: "Focus"),
    HabitIconOption(systemImage: "bubbles.and.sparkles.fill", label: "Relax"),
]

func habitIconSystemName(for title: String) -> String {

    // fallback icon based on hash so it looks different per habit
    let fallbackIcons = ["checkmark.circle.fill", "bolt.fill", "book.fill", "leaf.fill", "star.fill", "heart.fill"]
    let idx = abs(title.hashValue) % fallbackIcons.count
    return fallbackIcons[idx]
}
