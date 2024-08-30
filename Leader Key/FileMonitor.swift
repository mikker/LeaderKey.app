import Foundation

class FileMonitor {
  private var fileDescriptor: Int32 = -1
  private var source: DispatchSourceFileSystemObject?
  private var fileURL: URL?

  deinit {
    print("FileMonitor is being deallocated")
  }

  func startMonitoring(fileURL: URL, queue: DispatchQueue = .main, callback: @escaping () -> Void) {
    self.fileURL = fileURL

    // Ensure the file exists
    guard FileManager.default.fileExists(atPath: fileURL.path) else {
      print("File does not exist: \(fileURL.path)")
      return
    }

    // Open the file in read-only mode to get the file descriptor
    fileDescriptor = open(fileURL.path, O_EVTONLY)

    if fileDescriptor == -1 {
      print("Unable to open file: \(fileURL.path)")
      return
    }

    // Create a Dispatch Source that monitors the file for various events
    source = DispatchSource.makeFileSystemObjectSource(
      fileDescriptor: fileDescriptor,
      eventMask: [.delete, .write, .extend, .attrib, .link, .rename, .revoke],
      queue: queue
    )

    source?.setEventHandler { [weak self] in
      guard let self = self else { return }

      // Check if the file still exists
      if FileManager.default.fileExists(atPath: fileURL.path) {
        callback()
      } else {
        // File was deleted, wait for it to be recreated
        self.waitForFileRecreation(callback: callback)
      }
    }

    source?.setCancelHandler { [weak self] in
      guard let self = self else { return }
      close(self.fileDescriptor)
      self.fileDescriptor = -1
      self.source = nil
    }

    // Start monitoring
    source?.resume()
  }

  private func waitForFileRecreation(callback: @escaping () -> Void) {
    guard let fileURL = self.fileURL else { return }

    DispatchQueue.global(qos: .background).async { [weak self] in
      while !FileManager.default.fileExists(atPath: fileURL.path) {
        Thread.sleep(forTimeInterval: 0.1)
      }

      // File has been recreated, restart monitoring
      DispatchQueue.main.async {
        self?.stopMonitoring()
        self?.startMonitoring(fileURL: fileURL, callback: callback)
        callback()
      }
    }
  }

  func stopMonitoring() {
    source?.cancel()
  }
}
