import SwiftUI

struct MainTabView: View {
    let name: String

    var body: some View {
        TabView { // bottom nav bar
            mainView(name: name)
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            settingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}

#Preview {
    MainTabView(name: "Preview")
}
