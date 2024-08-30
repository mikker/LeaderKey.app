import Cocoa
import KeyboardShortcuts
import Settings
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  var window: Window!
  var controller: Controller!

  let statusItem = StatusItem()
  let config = UserConfig()

  var state: UserState!

  lazy var settingsWindowController = SettingsWindowController(
    panes: [
      Settings.Pane(
        identifier: .general, title: "General",
        toolbarIcon: NSImage(named: NSImage.preferencesGeneralName)!,
        contentView: { GeneralPane().environmentObject(self.config) }
      )
    ]
  )

  func applicationDidFinishLaunching(_: Notification) {
    guard ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" else { return }

    state = UserState(userConfig: config)

    controller = Controller(userState: state, userConfig: config)
    window = Window(controller: controller)
    controller.window = window

    config.afterReload = { _ in
      self.state.display = "🔃"

      self.show()
      delay(1000) {
        self.hide()
      }
    }

    config.loadAndWatch()

    statusItem.handlePreferences = {
      self.settingsWindowController.show()
    }
    statusItem.handleReloadConfig = {
      self.config.reloadConfig()
    }
    statusItem.handleRevealConfig = {
      NSWorkspace.shared.activateFileViewerSelecting([self.config.fileURL()])
    }
    statusItem.enable()

    KeyboardShortcuts.onKeyUp(for: .activate) {
      if self.window.isVisible && self.window.isKeyWindow {
        self.hide()
      } else {
        self.show()
      }
    }
  }

  @IBAction
  func settingsMenuItemActionHandler(_: NSMenuItem) {
    settingsWindowController.show()
  }

  func show() {
    controller.show()
  }

  func hide() {
    controller.hide()
  }
}
