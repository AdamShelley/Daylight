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

    
    var body: some View {
        VStack {
            Text("Settings")
                .font(.largeTitle)
                .padding()
            
            List {
                ForEach(settingsStore.scheduledTimes){time in
                    HStack {
                        Text(String(format: "%02d:%02d", time.hour, time.minute))
                        Spacer()
                        Button(role: .destructive) {
                            // remove this time and save
                            if let index = settingsStore.scheduledTimes.firstIndex(where: {$0.id == time.id})
                                {
                                settingsStore.scheduledTimes.remove(at: index)
                            }
                            settingsStore.save()
                        } label: {
                            Image(systemName: "minus.circle.fill")
                        }
                        .buttonStyle(.plain)
                    }
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
        .frame(minHeight: 150)

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
