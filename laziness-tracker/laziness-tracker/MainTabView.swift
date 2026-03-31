import SwiftUI

struct MainTabView: View {
    let name: String

    var body: some View {
        TabView { // bottom nav bar

            habitTrackerView()
                .tabItem {
                    Label("Habits", systemImage: "checkmark.circle")
                }

            settingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}

#Preview {
    MainTabView(name: "LeBron James")
}
