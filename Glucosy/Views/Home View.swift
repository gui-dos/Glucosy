import SwiftUI

struct HomeView: View {
    @Environment(AppState.self) private var app: AppState
    @Environment(Log.self) private var log: Log
    @Environment(History.self) private var history: History
    @Environment(Settings.self) private var settings: Settings
    
    var body: some View {
        @Bindable var settings = settings
        
        TabView(selection: $settings.selectedTab) {
            NavigationView {
                Monitor()
            }
            .tag(Tab.monitor)
            .tabItem {
                Label("Monitor", systemImage: "gauge")
            }
            
            NavigationView {
                DataView()
            }
            .tag(Tab.data)
            .tabItem {
                Label("Data", systemImage: "tray.full.fill")
            }
            
            NavigationView {
                AppleHealthView()
            }
            .tag(Tab.healthKit)
            .tabItem {
                Label("Apple Health", systemImage: "heart")
            }
            
            NavigationView {
                OnlineView()
            }
            .tag(Tab.online)
            .tabItem {
                Label("Online", systemImage: "globe")
            }
            
            NavigationView {
                Plan()
            }
            .tag(Tab.plan)
            .tabItem {
                Label("Plan", systemImage: "map")
            }
            
            NavigationView {
                SettingsView()
            }
            .tag(Tab.settings)
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
            
            NavigationView {
                ConsoleTab()
            }
            .tag(Tab.console)
            .tabItem {
                Label("Console", systemImage: "terminal")
            }
        }
        .toolbarRole(.navigationStack)
    }
}

#Preview {
    HomeView()
        .preferredColorScheme(.dark)
        .environment(AppState.test(tab: .monitor))
        .environment(Log())
        .environment(History.test)
        .environment(Settings())
}

#Preview {
    HomeView()
        .preferredColorScheme(.dark)
        .environment(AppState.test(tab: .online))
        .environment(Log())
        .environment(History.test)
        .environment(Settings())
}

#Preview {
    HomeView()
        .preferredColorScheme(.dark)
        .environment(AppState.test(tab: .data))
        .environment(Log())
        .environment(History.test)
        .environment(Settings())
}

#Preview {
    HomeView()
        .preferredColorScheme(.dark)
        .environment(AppState.test(tab: .console))
        .environment(Log())
        .environment(History.test)
        .environment(Settings())
}

#Preview {
    HomeView()
        .preferredColorScheme(.dark)
        .environment(AppState.test(tab: .settings))
        .environment(Log())
        .environment(History.test)
        .environment(Settings())
}
