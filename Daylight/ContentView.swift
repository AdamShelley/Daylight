import SwiftUI

struct ContentView: View {
    @State private var status: String = ""
    @State private var lastSavedPath: String? = nil
    @Environment(\.openSettings) private var openSettings
    
    let settingsStore: SettingsStore
    

    private let capture = ScreenCapture()
    private let cornerRadius: CGFloat = 20
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Header
            HStack {
                Image(systemName: "sun.max.fill")
                    .font(.title2)
                    .foregroundStyle(.orange)
                    .symbolRenderingMode(.hierarchical)
                
                Text("Daylight")
                    .font(.system(.headline, design: .rounded, weight: .semibold))
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)
            .padding(.bottom, 10)
            
            Divider()
                .opacity(0.4)
            
            // MARK: - Status section
            VStack(alignment: .leading, spacing: 10) {
                if status.isEmpty {
                    Text("Ready to capture")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } else {
                    Text(status)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .transition(.opacity)
                }
                
                if let path = lastSavedPath {
                    Text(path)
                        .font(.system(.caption, design: .monospaced))
                        .foregroundStyle(.secondary)
                        .textSelection(.enabled)
                        .lineLimit(2)
                        .truncationMode(.middle)
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(.quaternary.opacity(0.5))
                        )
                    
                    
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            
            // MARK: - Primary action
            Button {
                Task { await runCapture() }
            } label: {
                Label("Capture Now", systemImage: "camera.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .tint(.red)
            .keyboardShortcut(.defaultAction)
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
            
            Divider()
                .opacity(0.4)
            
            // MARK: - Footer
            HStack(spacing: 12) {
                Button {
                    NSApp.activate(ignoringOtherApps: true)
                    openSettings()
                } label: {
                    Label("Settings", systemImage: "gearshape")
                        .font(.caption)
                }
                .buttonStyle(.borderless)
                
                Spacer()
                
            
                Button {
                    if let path = lastSavedPath {
                        NSWorkspace.shared.activateFileViewerSelecting([URL(fileURLWithPath: path)])
                    } else  {
                        NSWorkspace.shared.open(settingsStore.saveFolder)
                    }
                } label: {
                    Label(lastSavedPath != nil ? "Reveal in Finder" : "Open Save Folder",
                          systemImage: "folder")
                        .font(.caption)
                }
                    .buttonStyle(.borderless)
                    .foregroundStyle(.tint)
            
                
                Spacer()
                
                Button {
                    NSApplication.shared.terminate(nil)
                } label: {
                    Text("Quit")
                        .font(.caption)
                }
                .buttonStyle(.borderless)
                .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .frame(width: 320)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(.regularMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .strokeBorder(.white.opacity(0.15), lineWidth: 1)
        )

        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .shadow(color: .black.opacity(0.25), radius: 20, y: 8)
        .padding(8)
    }
    
    private func runCapture() async {
        withAnimation { status = "Capturing…" }
        do {
            let url = try await capture.captureNow()
            withAnimation { status = "Saved ✓" }
            lastSavedPath = url.path
        } catch {
            withAnimation { status = "Error: \(error.localizedDescription)" }
            lastSavedPath = nil
        }
    }
}
