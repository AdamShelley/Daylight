//
//  CaptureScheduler.swift
//  Daylight
//
//  Created by Adam Shelley on 23/04/2026.
//

import Foundation
import UserNotifications

final class CaptureScheduler {
    private let settingsStore: SettingsStore
    private var timer: Timer?
    private let capture = ScreenCapture()
    let notificationCenter =  UNUserNotificationCenter.current()

    
    init(settingsStore: SettingsStore) {
        self.settingsStore = settingsStore
        requestNotificationPermission()
        self.timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true ){timer in
            let currentHour = Calendar.current.component(.hour, from: Date())
            let currentMinute = Calendar.current.component(.minute, from: Date())
            
            
            for time in settingsStore.scheduledTimes {
                let match = time.hour == currentHour && time.minute == currentMinute
                if match {
                    Task {
                        do {
                            _ = try await self.capture.captureNow()
                            print("Captured!")
                            let content = UNMutableNotificationContent()
                            content.title = "Daylight"
                            content.body = "Your screen was captured"
                            content.sound = UNNotificationSound.default
                            let request = UNNotificationRequest(identifier: "FiveSecond", content: content, trigger: nil)
                            let center = UNUserNotificationCenter.current()
                            try await center.add(request)

                        } catch {
                            print("Capture failed: \(error)")
                        }
           
                    }
                }
            }
        }
    }
    
    func requestNotificationPermission() {
        Task {
            do {
                try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound])
            } catch {
                print("Notification permission error: \(error)")
            }
        }
    }
}
