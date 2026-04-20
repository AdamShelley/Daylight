//
//  ScreenCapture.swift
//  Daylight
//
//  Created by Adam Shelley on 19/04/2026.
//
import Foundation
import ScreenCaptureKit
import AppKit

/// Handles capturing screenshots of the main display and saving them to disk.
@MainActor
final class ScreenCapture {

    /// Captures the main display and saves it as a PNG.
    /// Returns the URL of the saved file, or throws if something went wrong.
    func captureNow() async throws -> URL {
        // 1. Ask ScreenCaptureKit what's available to capture
        let content = try await SCShareableContent.current

        // 2. Pick the main display
        guard let display = content.displays.first else {
            throw CaptureError.noDisplayFound
        }

        // 3. Configure what we want to capture
        let filter = SCContentFilter(display: display, excludingWindows: [])

        let config = SCStreamConfiguration()
        config.width = display.width * 2   // Retina-friendly
        config.height = display.height * 2
        config.showsCursor = false

        // 4. Grab a single frame as a CGImage
        let cgImage = try await SCScreenshotManager.captureImage(
            contentFilter: filter,
            configuration: config
        )

        // 5. Convert to PNG data
        let bitmap = NSBitmapImageRep(cgImage: cgImage)
        guard let pngData = bitmap.representation(using: .png, properties: [:]) else {
            throw CaptureError.encodingFailed
        }

        // 6. Figure out where to save it
        let saveURL = try makeSaveURL()

        // 7. Write to disk
        try pngData.write(to: saveURL)

        return saveURL
    }

    /// Builds a URL like: ~/Library/Application Support/Daylight/2026-04-19T14-30-00.png
    private func makeSaveURL() throws -> URL {
        let fm = FileManager.default

        // Application Support is the conventional place for app data on macOS
        let appSupport = try fm.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )

        let folder = appSupport.appendingPathComponent("Daylight", isDirectory: true)
        try fm.createDirectory(at: folder, withIntermediateDirectories: true)

        // Timestamp-based filename, filesystem-safe
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate, .withTime]
        let stamp = formatter.string(from: Date())
            .replacingOccurrences(of: ":", with: "-")

        return folder.appendingPathComponent("\(stamp).png")
    }

    enum CaptureError: Error {
        case noDisplayFound
        case encodingFailed
    }
}
