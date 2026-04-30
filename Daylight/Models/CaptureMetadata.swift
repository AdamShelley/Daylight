//
//  CaptureMetadata.swift
//  Daylight
//
//  Created by Adam Shelley on 29/04/2026.
//

import Foundation

enum CaptureType: String, Codable {
    case scheduled
    case manual
}

struct CaptureMetadata: Codable, Identifiable {
    var id =  UUID()
    var dateSaved = Date()
    var type:  CaptureType = .scheduled
    var caption: String? = nil
}
