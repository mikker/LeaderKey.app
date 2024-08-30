import KeyboardShortcuts
import LaunchAtLogin
import Settings
import SwiftUI

struct GeneralPane: View {
  private let contentWidth = 250.0
  @EnvironmentObject private var config: UserConfig

  var body: some View {
    Settings.Container(contentWidth: contentWidth) {
      Settings.Section(title: "Shortcut") {
        KeyboardShortcuts.Recorder(for: .activate)
      }

      Settings.Section(title: "Config") {
        Button("Reveal in Finder") {
          NSWorkspace.shared.activateFileViewerSelecting([config.fileURL()])
        }
      }
      Settings.Section(title: "App") {
        LaunchAtLogin.Toggle()
      }
    }
  }
}

struct GeneralPane_Previews: PreviewProvider {
  static var previews: some View {
    GeneralPane()
      .environmentObject(UserConfig())
  }
}
