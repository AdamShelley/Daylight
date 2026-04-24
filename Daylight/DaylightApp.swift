//
//  DaylightApp.swift
//  Daylight
//
//  Created by Adam Shelley on 19/04/2026.
//

import SwiftUI
import Combine

@main
struct DaylightApp: App {
    @State private var settingsStore: SettingsStore
    @State private var scheduler: CaptureScheduler?


    init() {
        print("DaylightApp init — store created")
        let store = SettingsStore()
        _settingsStore = State(initialValue: store)
        _scheduler = State(initialValue: CaptureScheduler(settingsStore: store))
    }
    
    var body: some Scene {
        MenuBarExtra("Daylight", systemImage: "sun.max") {
            ContentView(settingsStore: settingsStore)
        }
        .menuBarExtraStyle(.window)
        .environment(settingsStore)
    }
}
