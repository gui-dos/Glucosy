import SwiftUI
import WidgetKit

struct SettingsView: View {
    @Environment(AppState.self) private var app: AppState
    @Environment(Settings.self) private var settings: Settings
    @EnvironmentObject          private var storage: Storage
    
    var body: some View {
        @Bindable var settings = settings
        
        List {
            Section {
                Toggle(isOn: $settings.caffeinated) {
                    Label("Iced caramel latte",
                          systemImage: settings.caffeinated ? "cup.and.saucer.fill" : "cup.and.saucer")
                    .foregroundStyle(.latte)
                }
            } footer: {
                Text("Keep the screen on when the app is running")
            }
            
            Picker("Glucose unit", selection: $settings.displayingMillimoles) {
                ForEach(GlucoseUnit.allCases) { unit in
                    Text(unit.description)
                        .tag(unit == .mmoll)
                }
            }
            .pickerStyle(.inline)
            .onChange(of: settings.displayingMillimoles) {
                WidgetCenter.shared.reloadAllTimelines()
            }
            
            let range = settings.preferredTransmitter == .abbott || (settings.preferredTransmitter == .none && app.transmitter != nil && app.transmitter.type == .transmitter(.abbott)) ?
            1...1:
            settings.preferredTransmitter == .dexcom || (settings.preferredTransmitter == .none && app.transmitter != nil && app.transmitter.type == .transmitter(.dexcom)) ?
            5...5: 1...15
            
            Stepper(value: $settings.readingInterval, in: range, step: 1) {
                Label("\(settings.readingInterval) min",
                      systemImage: "timer")
            }
            .foregroundColor(.orange)
            
            Stepper {
                Label(settings.onlineInterval > 0 ? "\(settings.onlineInterval) min" : "offline",
                      systemImage: settings.onlineInterval > 0 ? "network" : "wifi.slash")
                
            } onIncrement: {
                settings.onlineInterval += settings.onlineInterval >= 5 ? 5 : 1
                
            } onDecrement: {
                settings.onlineInterval -= settings.onlineInterval == 0 ? 0 : settings.onlineInterval <= 5 ? 1 : 5
            }
            .foregroundColor(.cyan)
            
            Section("Bluetooth") {
                Button("Rescan") {
                    settings.selectedTab = (settings.preferredTransmitter != .none) ? .monitor : .console
                    app.main.rescan()
                }
                
                Button {
                    settings.stoppedBluetooth.toggle()
                    
                    if settings.stoppedBluetooth {
                        app.main.centralManager.stopScan()
                        app.main.status("Stopped scanning")
                        app.main.log("Bluetooth: stopped scanning")
                    } else {
                        app.main.rescan()
                    }
                } label: {
                    Image(.bluetooth)
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 32, height: 32)
                        .overlay {
                            if settings.stoppedBluetooth {
                                Image(systemName: "line.diagonal")
                                    .resizable()
                                    .foregroundColor(.red)
                                    .frame(width: 24, height: 24)
                                    .rotationEffect(.degrees(90))
                            }
                        }
                }
                
                Picker("Preferred", selection: $settings.preferredTransmitter) {
                    ForEach(TransmitterType.allCases) { t in
                        Text(t.name)
                            .tag(t)
                    }
                }
                .pickerStyle(.segmented)
                .disabled(settings.stoppedBluetooth)
                
                TextField("device name pattern", text: $settings.preferredDevicePattern)
            }
            
            HStack {
                Text("Target zone")
                
                Spacer()
                
                Text("\(settings.targetLow.units) - \(settings.targetHigh.units)")
                    .foregroundColor(.green)
            }
            
            Group {
                Slider(value: $settings.targetLow, in: 40...99, step: 1) {
                    Text("Min")
                }
                
                Slider(value: $settings.targetHigh, in: 120...300, step: 1) {
                    Text("Max")
                }
            }
            .tint(.green)
            
            HStack {
                Text("Alert when")
                
                Spacer()
                
                Text("<\(settings.alarmLow.units) and >\(settings.alarmHigh.units)")
                    .foregroundColor(.red)
            }
            
            Group {
                Slider(value: $settings.alarmLow, in: 40...99, step: 1) {
                    Text("Min")
                }
                
                Slider(value: $settings.alarmHigh, in: 120...300, step: 1) {
                    Text("Max")
                }
            }
            .tint(.red)
            
            SettingsNotification()
            
            SettingsCalendar()
            
            Section {
                Toggle("Debug mode", isOn: $storage.debugMode)
            }
        }
        .standardToolbar()
        .navigationTitle("Settings")
        .monospacedDigit()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button {
                settings.mutedAudio.toggle()
            } label: {
                Image(systemName: settings.mutedAudio ? "speaker.slash.fill" : "speaker.2.fill")
            }
        }
    }
}

#Preview {
    HomeView()
        .glucosyPreview(.settings)
}
