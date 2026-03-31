//
//  habitTrackerView.swift
//  laziness-tracker
//
//  Created by Reilan Sagun on 2026-03-28.
//

import SwiftUI

private let habitsStorageKey = "habitTracker.habits.v1"

private func dayKey(for date: Date) -> String {
    let cal = Calendar.current
    let c = cal.dateComponents([.year, .month, .day], from: date)
    guard let y = c.year, let m = c.month, let d = c.day else { return "" }
    return String(format: "%04d-%02d-%02d", y, m, d)
}


struct Habit: Identifiable, Codable, Equatable {
    var id: UUID
    var title: String
    var iconSystemName: String?
    var completedDayKeys: Set<String>
}

@Observable
final class HabitStore {
    private(set) var habits: [Habit] = []

    init() {
        load()
    }

    func add(title: String, iconSystemName: String?) {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        // Prevent duplicates (case-insensitive).
        if habits.contains(where: { $0.title.caseInsensitiveCompare(trimmed) == .orderedSame }) { return }
        habits.append(Habit(id: UUID(), title: trimmed, iconSystemName: iconSystemName, completedDayKeys: []))
        save()
    }

    func delete(id: UUID) {
        habits.removeAll { $0.id == id }
        save()
    }

    func remove(title: String) {
        guard let habit = habits.first(where: { $0.title.caseInsensitiveCompare(title) == .orderedSame }) else { return }
        delete(id: habit.id)
    }

    func isCompleted(_ habit: Habit, on date: Date) -> Bool {
        habit.completedDayKeys.contains(dayKey(for: date))
    }

    func toggle(_ habit: Habit, on date: Date) {
        guard let idx = habits.firstIndex(where: { $0.id == habit.id }) else { return }
        let key = dayKey(for: date)
        if habits[idx].completedDayKeys.contains(key) { habits[idx].completedDayKeys.remove(key) }
        else { habits[idx].completedDayKeys.insert(key) }
        save()
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: habitsStorageKey) else { return }
        guard let decoded = try? JSONDecoder().decode([Habit].self, from: data) else { return }
        habits = decoded
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(habits) else { return }
        UserDefaults.standard.set(data, forKey: habitsStorageKey)
    }
}

struct habitTrackerView: View {
    @State private var store = HabitStore()
    @State private var newTitle = ""
    @State private var isAdding = false

    @State private var selectedDate = Date()

    @State private var newIconSystemName: String?
    @State private var isIconPickerCollapsed = true

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @AppStorage("userName") private var name: String = ""

    var body: some View {
        NavigationStack {
            TimelineView(.atHourBoundaries) { context in
                let greeting = name.isEmpty ? "\(context.date.timeGreeting)!" : "\(context.date.timeGreeting), \(name)!"
                ZStack {
                    Color(.systemGroupedBackground).ignoresSafeArea()
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            Text(greeting)
                                .font(.title2.bold())
                                .padding(.top)
                                .padding(.horizontal)

                            if horizontalSizeClass == .regular {
                                dailyCard()
                                    .padding(.horizontal)
                            } else {
                                dailyCard()
                                    .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Habits")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        newTitle = ""
                        isAdding = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isAdding) {
                NavigationStack {
                    Form {
                        Section {
                            TextField("Habit name", text: $newTitle)
                                .textInputAutocapitalization(.sentences)
                        }

                        Section {
                            Button {
                                withAnimation(.easeInOut(duration: 0.2)) { isIconPickerCollapsed.toggle() }
                            } label: {
                                HStack {
                                    Text("Choose icon")
                                    Spacer()
                                    if let name = newIconSystemName {
                                        Image(systemName: name)
                                            .foregroundStyle(.secondary)
                                    }
                                    Image(systemName: isIconPickerCollapsed ? "chevron.down" : "chevron.up")
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .buttonStyle(.plain)
                            if !isIconPickerCollapsed {
                                let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
                                LazyVGrid(columns: columns, spacing: 12) {
                                    ForEach(habitIconOptions) { option in
                                        let selected = option.systemImage == newIconSystemName
                                        Button {
                                            newIconSystemName = option.systemImage
                                        } label: {
                                            VStack(spacing: 6) {
                                                Image(systemName: option.systemImage)
                                                    .font(.title3)
                                                    .foregroundStyle(selected ? .orange : .secondary)
                                            }
                                            .padding(12)
                                            .frame(maxWidth: .infinity)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                    .fill(selected ? Color.orange.opacity(0.18) : .clear)
                                            )
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                    .stroke(selected ? Color.orange.opacity(0.8) : Color.black.opacity(0.08), lineWidth: 1)
                                            )
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                        } header: { Text("Icon") }

                    }
                    .navigationTitle("New habit")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { isAdding = false }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                store.add(title: newTitle, iconSystemName: newIconSystemName)
                                isAdding = false
                            }
                            .disabled(newTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        }
                    }
                    .onAppear {
                        if newIconSystemName == nil {
                            newIconSystemName = habitIconOptions.first?.systemImage
                        }
                    }
                }
            }
        }
    }

    private func dailyCard() -> some View {
        CardShell {
            VStack(alignment: .leading, spacing: 12) {
                if !store.habits.isEmpty {
                    HStack {
                        Text("Habits")
                            .font(.headline)
                        Spacer()
                    }

                    let doneCount = store.habits.reduce(0) { count, habit in
                        count + (store.isCompleted(habit, on: selectedDate) ? 1 : 0)
                    }
                    let totalCount = store.habits.count

                    VStack(alignment: .leading, spacing: 10) {
                        Text("\(doneCount)/\(totalCount) done")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        ForEach(store.habits) { habit in
                                let completed = store.isCompleted(habit, on: selectedDate)
                                Button {
                                    store.toggle(habit, on: selectedDate)
                                } label: {
                                    HStack(spacing: 12) {
                                        Image(systemName: habit.iconSystemName ?? habitIconSystemName(for: habit.title))
                                            .foregroundStyle(completed ? .green : .secondary)
                                        Text(habit.title)
                                            .strikethrough(completed, color: .secondary)
                                            .foregroundStyle(completed ? .secondary : .primary)
                                        Spacer()
                                        Image(systemName: completed ? "checkmark.circle.fill" : "circle")
                                            .foregroundStyle(completed ? .green : .secondary)
                                    }
                                    .padding(.vertical, 6)
                                }
                                .buttonStyle(.plain)
                            }
                    }
                    .padding(.top, 6)
                } else {
                    ContentUnavailableView(
                        "Add your first habit",
                        systemImage: "checkmark.circle",
                        description: Text("Tap the `+` button to create a habit.")
                    )
                }
            }
        }
    }

}

#Preview {
    habitTrackerView()
}
