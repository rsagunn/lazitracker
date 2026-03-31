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
    guard let y = c.year, let m = c.month, let d = c.day else { return "" } // if one component fails return ""
    return String(format: "%04d-%02d-%02d", y, m, d) // eg 2026 12 26
}


struct Habit: Identifiable, Codable, Equatable {
    var id: UUID // unique id
    var title: String // habit name
    var iconSystemName: String? // optional for icon or no icon
    var completedDayKeys: Set<String> // day habit was complete
}

@Observable // updates if data changes
final class HabitStore { // cant be used in another class
    private(set) var habits: [Habit] = [] // only this class can write

    init() {
        load()
    }

    func add(title: String, iconSystemName: String?) {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return } // no empty habits
        if habits.contains(where: { $0.title.caseInsensitiveCompare(trimmed) == .orderedSame }) { return } // compares 2 strings case insensitive to prevent dupes
        habits.append(Habit(id: UUID(), title: trimmed, iconSystemName: iconSystemName, completedDayKeys: [])) // add to end of list
        save()
    }

    func isCompleted(_ habit: Habit, on date: Date) -> Bool {
        habit.completedDayKeys.contains(dayKey(for: date)) // returns boolean if completed or not
    }

    func toggle(_ habit: Habit, on date: Date) {
        guard let idx = habits.firstIndex(where: { $0.id == habit.id }) else { return } // find index of habits in array by matching habit uuid if nil return
        let key = dayKey(for: date) 
        if habits[idx].completedDayKeys.contains(key) { habits[idx].completedDayKeys.remove(key) } // check if completed if it is remove daykey to mark not complete
        else { habits[idx].completedDayKeys.insert(key) } // if not add daykey
        save()
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: habitsStorageKey) else { return } // try to get data if none return
        guard let decoded = try? JSONDecoder().decode([Habit].self, from: data) else { return } // try to decode data into array if fails return
        habits = decoded // assign decoded to habbit array
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(habits) else { return } // try to convert into json if fails return
        UserDefaults.standard.set(data, forKey: habitsStorageKey) // save to userdefault
    }
}

struct habitTrackerView: View {
    @State private var store = HabitStore()
    @State private var newTitle = "" // title input of habit
    @State private var isAdding = false // new habit sheet

    @State private var selectedDate = Date() // selected day default today

    @State private var newIconSystemName: String? // icon for habit
    @State private var isIconPickerCollapsed = true // icon picker minimize 

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass // make ui adapt to screen width
    @AppStorage("userName") private var name: String = "" // username

    var body: some View {
        NavigationStack {
            TimelineView(.atHourBoundaries) { context in
                let greeting = name.isEmpty ? "\(context.date.timeGreeting)!" : "\(context.date.timeGreeting), \(name)!" //  greeeting name
                ZStack {
                    Color(.systemGroupedBackground).ignoresSafeArea()
                    ScrollView { // allow scrolling
                        VStack(alignment: .leading, spacing: 16) {
                            Text(greeting)
                                .font(.title2.bold())
                                .padding(.top)
                                .padding(.horizontal)

                            dailyCard()
                            .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Habits") // app title
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
            .sheet(isPresented: $isAdding) { // new page toggle isadding
                NavigationStack {
                    Form {
                        Section {
                            TextField("Habit name", text: $newTitle) // upd newtitle
                                .textInputAutocapitalization(.sentences) // auto cap first letter
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
                            if !isIconPickerCollapsed { // show if is open
                                let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())] // 3 grid col layout streches equally to width of screen
                                LazyVGrid(columns: columns, spacing: 12) {
                                    ForEach(habitIconOptions) { option in // put all icons in
                                        let selected = option.systemImage == newIconSystemName
                                        Button {
                                            newIconSystemName = option.systemImage // when tapped select icon
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
                        ToolbarItem(placement: .cancellationAction) { // cancel btn
                            Button("Cancel") { isAdding = false }
                        }
                        ToolbarItem(placement: .confirmationAction) { // add btn
                            Button("Add") {
                                store.add(title: newTitle, iconSystemName: newIconSystemName)
                                isAdding = false
                            }
                            .disabled(newTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) // disable if no name input
                        }
                    }
                    .onAppear {
                        if newIconSystemName == nil {
                            newIconSystemName = habitIconOptions.first?.systemImage // auto pick first icon
                        }
                    }
                }
            }
        }
    }

    private func dailyCard() -> some View {
        CardShell { // rouunded bg
            VStack(alignment: .leading, spacing: 12) {
                if !store.habits.isEmpty { // only show if u have habits
                    HStack {
                        Text("Habits")
                            .font(.headline)
                        Spacer()
                    }

                    let doneCount = store.habits.reduce(0) { count, habit in
                        count + (store.isCompleted(habit, on: selectedDate) ? 1 : 0) // count how mny u finished
                    }
                    let totalCount = store.habits.count // count all habits

                    VStack(alignment: .leading, spacing: 10) {
                        Text("\(doneCount)/\(totalCount) done") // ratio of how many u done
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        ForEach(store.habits) { habit in
                                let completed = store.isCompleted(habit, on: selectedDate) // check if each habit is complete
                                Button {
                                    store.toggle(habit, on: selectedDate) // mark done
                                } label: {
                                    HStack(spacing: 12) {
                                        Image(systemName: habit.iconSystemName ?? habitIconSystemName(for: habit.title)) // turn habit icon green
                                            .foregroundStyle(completed ? .green : .secondary)
                                        Text(habit.title) // line out
                                            .strikethrough(completed, color: .secondary)
                                            .foregroundStyle(completed ? .secondary : .primary)
                                        Spacer()
                                        Image(systemName: completed ? "checkmark.circle.fill" : "circle") //checkmark
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
