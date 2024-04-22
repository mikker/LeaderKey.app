//
//  GeneralPane.swift
//  Leader Key
//
//  Created by Mikkel Malmberg on 23/09/2020.
//

import Defaults
import KeyboardShortcuts
import LaunchAtLogin
import Settings
import SwiftUI

struct GeneralPane: View {
    private let contentWidth = 250.0

    @State private var l = LaunchAtLogin.observable

    var body: some View {
        Settings.Container(contentWidth: contentWidth) {
            Settings.Section(title: "Shortcut") {
                KeyboardShortcuts.Recorder(for: .activate)
            }

            Settings.Section(title: "Config file") {
                Defaults.Toggle("Watch for changes", key: .watchConfigFile)
            }

            Settings.Section(title: "App") {
                Toggle("Launch at login", isOn: $l.isEnabled)
            }
        }
    }
}

struct GeneralPane_Previews: PreviewProvider {
    static var previews: some View {
        GeneralPane()
    }
}
