import Carbon.HIToolbox
import CoreGraphics

enum RightCommandTapEvent {
  case flagsChanged(keyCode: CGKeyCode, flags: CGEventFlags)
  case keyDown
  case mouseDown
}

struct RightCommandTapState {
  private var isRightCommandDown = false
  private var shouldActivate = false
  private var heldOtherModifiers = Set<CGKeyCode>()

  mutating func handle(_ event: RightCommandTapEvent) -> Bool {
    switch event {
    case .flagsChanged(let keyCode, let flags):
      return handleModifierChange(keyCode: keyCode, flags: flags)
    case .keyDown, .mouseDown:
      if isRightCommandDown {
        shouldActivate = false
      }
      return false
    }
  }

  mutating func reset() {
    isRightCommandDown = false
    shouldActivate = false
    heldOtherModifiers.removeAll()
  }

  private mutating func handleModifierChange(keyCode: CGKeyCode, flags: CGEventFlags) -> Bool {
    if keyCode == CGKeyCode(kVK_RightCommand) {
      if isRightCommandDown {
        isRightCommandDown = false
        defer { shouldActivate = false }
        return shouldActivate
      }

      isRightCommandDown = true
      shouldActivate = heldOtherModifiers.isEmpty
      return false
    }

    updateHeldModifiers(keyCode: keyCode, flags: flags)

    if isRightCommandDown {
      shouldActivate = false
    }

    return false
  }

  private mutating func updateHeldModifiers(keyCode: CGKeyCode, flags: CGEventFlags) {
    guard let modifierFlag = modifierFlag(for: keyCode) else {
      return
    }

    if flags.contains(modifierFlag) {
      heldOtherModifiers.insert(keyCode)
    } else {
      heldOtherModifiers.remove(keyCode)
    }
  }

  private func modifierFlag(for keyCode: CGKeyCode) -> CGEventFlags? {
    switch keyCode {
    case CGKeyCode(kVK_Command):
      return .maskCommand
    case CGKeyCode(kVK_Shift), CGKeyCode(kVK_RightShift):
      return .maskShift
    case CGKeyCode(kVK_Option), CGKeyCode(kVK_RightOption):
      return .maskAlternate
    case CGKeyCode(kVK_Control), CGKeyCode(kVK_RightControl):
      return .maskControl
    case CGKeyCode(kVK_Function):
      return .maskSecondaryFn
    default:
      return nil
    }
  }
}

final class RightCommandMonitor {
  private var eventTap: CFMachPort?
  private var runLoopSource: CFRunLoopSource?
  private var state = RightCommandTapState()
  private let onTap: () -> Void

  init(onTap: @escaping () -> Void) {
    self.onTap = onTap
  }

  deinit {
    stop()
  }

  var hasInputMonitoringPermission: Bool {
    CGPreflightListenEventAccess()
  }

  @discardableResult
  func start() -> Bool {
    guard eventTap == nil, hasInputMonitoringPermission else {
      return eventTap != nil
    }

    let eventMask = eventMask(
      for: [
        .flagsChanged,
        .keyDown,
        .leftMouseDown,
        .rightMouseDown,
        .otherMouseDown,
      ]
    )
    let userInfo = Unmanaged.passUnretained(self).toOpaque()
    guard
      let eventTap = CGEvent.tapCreate(
        tap: .cgSessionEventTap,
        place: .headInsertEventTap,
        options: .listenOnly,
        eventsOfInterest: eventMask,
        callback: Self.eventTapCallback,
        userInfo: userInfo
      )
    else {
      return false
    }

    guard let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
    else {
      CFMachPortInvalidate(eventTap)
      return false
    }

    self.eventTap = eventTap
    self.runLoopSource = runLoopSource
    CFRunLoopAddSource(CFRunLoopGetMain(), runLoopSource, .commonModes)
    CGEvent.tapEnable(tap: eventTap, enable: true)
    return true
  }

  func stop() {
    if let runLoopSource {
      CFRunLoopRemoveSource(CFRunLoopGetMain(), runLoopSource, .commonModes)
    }
    if let eventTap {
      CFMachPortInvalidate(eventTap)
    }

    runLoopSource = nil
    eventTap = nil
    state.reset()
  }

  private func receive(type: CGEventType, event: CGEvent) {
    switch type {
    case .tapDisabledByTimeout, .tapDisabledByUserInput:
      if let eventTap {
        CGEvent.tapEnable(tap: eventTap, enable: true)
      }
      return
    case .flagsChanged:
      let keyCode = CGKeyCode(event.getIntegerValueField(.keyboardEventKeycode))
      activateIfNeeded(for: .flagsChanged(keyCode: keyCode, flags: event.flags))
    case .keyDown:
      activateIfNeeded(for: .keyDown)
    case .leftMouseDown, .rightMouseDown, .otherMouseDown:
      activateIfNeeded(for: .mouseDown)
    default:
      return
    }
  }

  private func activateIfNeeded(for event: RightCommandTapEvent) {
    guard state.handle(event) else {
      return
    }

    DispatchQueue.main.async { [weak self] in
      self?.onTap()
    }
  }

  private static let eventTapCallback: CGEventTapCallBack = { _, type, event, userInfo in
    if let userInfo {
      let monitor = Unmanaged<RightCommandMonitor>.fromOpaque(userInfo).takeUnretainedValue()
      monitor.receive(type: type, event: event)
    }
    return Unmanaged.passUnretained(event)
  }

  private func eventMask(for eventTypes: [CGEventType]) -> CGEventMask {
    eventTypes.reduce(CGEventMask(0)) { mask, eventType in
      mask | (CGEventMask(1) << eventType.rawValue)
    }
  }
}
