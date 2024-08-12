import Defaults
import KeyboardShortcuts
import LaunchAtLogin
import Settings
import SwiftUI

struct GeneralPane: View {
    private let contentWidth = 250.0

    var body: some View {
        Settings.Container(contentWidth: contentWidth) {
            Settings.Section(title: "Shortcut") {
                KeyboardShortcuts.Recorder(for: .activate)
            }

            Settings.Section(title: "Config file") {
                Defaults.Toggle("Watch for changes", key: .watchConfigFile)
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
    }
}
