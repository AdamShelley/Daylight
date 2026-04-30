//
//  Untitled.swift
//  Daylight
//
//  Created by Adam Shelley on 20/04/2026.
//

import Foundation

@Observable
final class SettingsStore {
    var scheduledTimes: [ScheduledTime] = []
    var saveFolder: URL
    
    
    private var fileURL: URL {
        saveFolder.appendingPathComponent("settings.json")
    }
    
    init() {
        do {
            let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
            self.saveFolder = base.appendingPathComponent("Daylight")

        } catch {
            print(error)
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            scheduledTimes = try JSONDecoder().decode([ScheduledTime].self, from: data)
            print(scheduledTimes)
        } catch {
            print(error)
        }
    }
    
    func save() {
        do {
             try JSONEncoder().encode(scheduledTimes).write(to: fileURL)
        } catch {
            print(error)
        }
        
        
    }
    
    
}
