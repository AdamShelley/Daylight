//
//  SettingsView.swift
//  Daylight
//
//  Created by Adam Shelley on 21/04/2026.
//

import SwiftUI

struct SettingsView: View {
    let settingsStore: SettingsStore
    
    var body: some View {
        VStack {
            Text("Settings")
                .font(.largeTitle)
                .padding()
            
            List {
                ForEach(settingsStore.scheduledTimes){time in
                    Text("\(time.hour):\(time.minute)")
                }
                .onDelete { indexSet in
                    settingsStore.scheduledTimes.remove(atOffsets: indexSet)
                    settingsStore.save()

                }
            }
        }
        .padding(16)
        .frame(width: 280)
    }
}
