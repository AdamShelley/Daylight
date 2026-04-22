//
//  DaylightApp.swift
//  Daylight
//
//  Created by Adam Shelley on 19/04/2026.
//

import SwiftUI

@main
struct DaylightApp: App {
    @State private var settingsStore = SettingsStore()
    
    init() {
        print("DaylightApp init — store created")
    }
    
    var body: some Scene {
        MenuBarExtra("Daylight", systemImage: "sun.max") {
            ContentView(settingsStore: settingsStore)
        }
        .menuBarExtraStyle(.window)
        .environment(settingsStore)
    }
}
