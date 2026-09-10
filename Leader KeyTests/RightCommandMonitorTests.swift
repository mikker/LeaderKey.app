import Carbon.HIToolbox
import CoreGraphics
import XCTest

@testable import Leader_Key

final class RightCommandMonitorTests: XCTestCase {
  func testTapRightCommandActivatesOnRelease() {
    var state = RightCommandTapState()

    XCTAssertFalse(rightCommandDown(&state))
    XCTAssertTrue(rightCommandUp(&state))
  }

  func testLeftCommandDoesNotActivate() {
    var state = RightCommandTapState()

    XCTAssertFalse(
      state.handle(.flagsChanged(keyCode: CGKeyCode(kVK_Command), flags: [.maskCommand])))
    XCTAssertFalse(
      state.handle(.flagsChanged(keyCode: CGKeyCode(kVK_Command), flags: [])))
  }

  func testKeyPressedWhileRightCommandIsHeldCancelsActivation() {
    var state = RightCommandTapState()

    XCTAssertFalse(rightCommandDown(&state))
    XCTAssertFalse(state.handle(.keyDown))
    XCTAssertFalse(rightCommandUp(&state))
  }

  func testAdditionalModifierCancelsActivation() {
    var state = RightCommandTapState()

    XCTAssertFalse(rightCommandDown(&state))
    XCTAssertFalse(
      state.handle(.flagsChanged(keyCode: CGKeyCode(kVK_Shift), flags: [.maskCommand, .maskShift])))
    XCTAssertFalse(rightCommandUp(&state))
  }

  func testRightCommandDoesNotActivateWhenLeftCommandIsHeldFirst() {
    var state = RightCommandTapState()

    XCTAssertFalse(
      state.handle(.flagsChanged(keyCode: CGKeyCode(kVK_Command), flags: [.maskCommand])))
    XCTAssertFalse(rightCommandDown(&state))
    XCTAssertFalse(rightCommandUp(&state))
  }

  func testMouseClickWhileRightCommandIsHeldCancelsActivation() {
    var state = RightCommandTapState()

    XCTAssertFalse(rightCommandDown(&state))
    XCTAssertFalse(state.handle(.mouseDown))
    XCTAssertFalse(rightCommandUp(&state))
  }

  private func rightCommandDown(_ state: inout RightCommandTapState) -> Bool {
    state.handle(.flagsChanged(keyCode: CGKeyCode(kVK_RightCommand), flags: [.maskCommand]))
  }

  private func rightCommandUp(_ state: inout RightCommandTapState) -> Bool {
    state.handle(.flagsChanged(keyCode: CGKeyCode(kVK_RightCommand), flags: []))
  }
}
