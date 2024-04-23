//
//  StatusItem.swift
//  Leader Key
//
//  Created by Mikkel Malmberg on 23/02/2020.
//  Copyright © 2020 Brainbow. All rights reserved.
//

import Cocoa

class StatusItem {
    var statusItem: NSStatusItem?

    var handlePreferences: (() -> Void)?
    var handleReloadConfig: (() -> Void)?
    var handleRevealConfig: (() -> Void)?

    func enable() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        guard let item = statusItem else {
            print("No status item")
            return
        }

        if let menubarButton = item.button {
            menubarButton.image = NSImage(named: NSImage.Name("StatusItem"))
        }

        let menu = NSMenu()

        let preferencesItem = NSMenuItem(
            title: "Preferences…", action: #selector(showPreferences), keyEquivalent: ","
        )
        preferencesItem.target = self
        menu.addItem(preferencesItem)

        menu.addItem(NSMenuItem.separator())

        let revealConfigItem = NSMenuItem(title: "Show config in Finder", action: #selector(revealConfigFile), keyEquivalent: "")
        revealConfigItem.target = self
        menu.addItem(revealConfigItem)

        let reloadConfigItem = NSMenuItem(
            title: "Reload config", action: #selector(reloadConfig), keyEquivalent: ""
        )
        reloadConfigItem.target = self
        menu.addItem(reloadConfigItem)

        menu.addItem(NSMenuItem.separator())

        menu.addItem(
            NSMenuItem(
                title: "Quit Leader Key", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"
            ))

        item.menu = menu
    }

    @objc func showPreferences() {
        handlePreferences?()
    }

    @objc func reloadConfig() {
        handleReloadConfig?()
    }

    @objc func revealConfigFile() {
        handleRevealConfig?()
    }
}
