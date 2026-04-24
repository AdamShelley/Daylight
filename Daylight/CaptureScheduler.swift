//
//  CaptureScheduler.swift
//  Daylight
//
//  Created by Adam Shelley on 23/04/2026.
//

import Foundation

final class CaptureScheduler {
    private let settingsStore: SettingsStore
    private var timer: Timer?
    private let capture = ScreenCapture()
    
    init(settingsStore: SettingsStore) {
        self.settingsStore = settingsStore
        self.timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true ){timer in
            let currentHour = Calendar.current.component(.hour, from: Date())
            let currentMinute = Calendar.current.component(.minute, from: Date())
            
            for time in settingsStore.scheduledTimes {
                let match = time.hour == currentHour && time.minute == currentMinute
                if match {
                    Task {
                        do {
                            _ = try await self.capture.captureNow()
                            print("CAptured!")
                        } catch {
                            print("Capture failed: \(error)")
                        }
                        
                    }
                }
            }
            
        }
        
    }
    
}
