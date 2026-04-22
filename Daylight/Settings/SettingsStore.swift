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
    
    
    
    private var fileURL: URL {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let folder = base.appendingPathComponent("Daylight")
        return folder.appendingPathComponent("settings.json")
    }
    
    init() {
        do {
            try FileManager.default.createDirectory(at: fileURL.deletingLastPathComponent(), withIntermediateDirectories: true)
            
            

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
