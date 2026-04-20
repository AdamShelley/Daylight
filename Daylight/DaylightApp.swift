//
//  DaylightApp.swift
//  Daylight
//
//  Created by Adam Shelley on 19/04/2026.
//

import SwiftUI

@main
struct DaylightApp: App {
    var body: some Scene {
        MenuBarExtra("Daylight", systemImage:"sun.max"){
            ContentView()
        }
        .menuBarExtraStyle(.window)
    }
}
