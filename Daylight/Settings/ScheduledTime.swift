//
//  ScheduledTime.swift
//  Daylight
//
//  Created by Adam Shelley on 20/04/2026.
//

import Foundation

struct ScheduledTime: Codable, Identifiable {
    var id =  UUID()
    var hour: Int = 0
    var minute: Int = 0
    var enabled: Bool = true
}
