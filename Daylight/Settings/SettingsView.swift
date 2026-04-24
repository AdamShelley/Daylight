//
//  SettingsView.swift
//  Daylight
//
//  Created by Adam Shelley on 21/04/2026.
//

import SwiftUI

struct SettingsView: View {
    @State private var selectedTime: Date = Date()

    let settingsStore: SettingsStore
    
    enum CaptureFrequency: String, Codable, CaseIterable {
        case daily = "Daily"
        case weekly = "Weekly"
    }
    
    var body: some View {
        VStack {
            Text("Settings")
                .font(.largeTitle)
                .padding()
            
            List {
                ForEach(settingsStore.scheduledTimes){time in
                    Text(String(format: "%02d:%02d", time.hour, time.minute)
)
                }
                .onDelete { indexSet in
                    settingsStore.scheduledTimes.remove(atOffsets: indexSet)
                    settingsStore.save()

                }
            }
            
            DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                .labelsHidden()
            
    
            
            Button("Add"){
               addTime()
            }
        }
        .padding(16)
        .frame(width: 280)
    }
    
    func addTime() {
        // Todo
        let hour = Calendar.current.component(.hour, from: selectedTime)
        let minute = Calendar.current.component(.minute, from: selectedTime)
        let newTime = ScheduledTime(hour: hour, minute: minute)
        settingsStore.scheduledTimes.append(newTime)
        settingsStore.save()
    }
}
