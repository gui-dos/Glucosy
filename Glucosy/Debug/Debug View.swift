import SwiftUI

struct DebugView: View {
    @Environment(AppState.self) private var app
    @Environment(History.self)  private var history
    @EnvironmentObject          private var storage: Storage
    
    @State private var scheduledNotifications: [UNNotificationRequest] = []
    
    private var notificationManager = NotificationManager()
    
    var body: some View {
        List {
            Section {
                Toggle("Debug mode", isOn: $storage.debugMode)
            }
            
            NavigationLink {
                DataView()
            } label: {
                Label("Data", systemImage: "tray.full.fill")
            }
            
            Section("Scheduled notifications") {
                Button("Cancel all") {
                    notificationManager.removeAllPending()
                }
                
                ForEach(scheduledNotifications, id: \.identifier) { notification in
                    VStack {
                        Text(notification.content.title)
                        
                        Text(notification.content.subtitle)
                        
                        if let trigger = notification.trigger as? UNTimeIntervalNotificationTrigger {
                            Text("Interval: \(trigger.timeInterval)")
                        }
                    }
                    .contextMenu {
                        Button(role: .destructive) {
                            notificationManager.removePending(notification.identifier)
                        } label: {
                            Label("Cancel", systemImage: "trash")
                        }
                    }
                }
            }
        }
        .navigationTitle("Debug")
        .refreshableTask {
            scheduledNotifications = await notificationManager.fetchScheduledNotifications()
        }
    }
}

#Preview {
    DebugView()
        .glucosyPreview()
}