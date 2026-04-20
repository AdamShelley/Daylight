//
//  ContentView.swift
//  Daylight
//
//  Created by Adam Shelley on 19/04/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var status: String = "Ready"
    @State private var lastSavedPath: String? = nil

    private let capture = ScreenCapture()

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Daylight")
                .font(.headline)

            Text(status)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if let path = lastSavedPath {
                Text(path)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .textSelection(.enabled)
                    .lineLimit(3)

                Button("Reveal in Finder") {
                    NSWorkspace.shared.activateFileViewerSelecting([URL(fileURLWithPath: path)])
                }
                .buttonStyle(.link)
            }

            Button("Capture Now") {
                Task {
                    await runCapture()
                }
            }
            .keyboardShortcut(.defaultAction)

            Button("Quit Daylight") {
                NSApplication.shared.terminate(nil)
            }
        }
        .padding(16)
        .frame(width: 280)
    }

    private func runCapture() async {
        status = "Capturing…"
        do {
            let url = try await capture.captureNow()
            status = "Saved ✓"
            lastSavedPath = url.path
        } catch {
            status = "Error: \(error.localizedDescription)"
            lastSavedPath = nil
        }
    }
}

#Preview {
    ContentView()
}
