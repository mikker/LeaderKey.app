//
//  FileMonitor.swift
//  Leader Key
//
//  Created by Mikkel Malmberg on 21/04/2024.
//

import Foundation

class FileMonitor {
    private var fileDescriptor: Int32 = -1
    private var source: DispatchSourceFileSystemObject?

    deinit {
        print("FileMonitor is being deallocated")
    }

    func startMonitoring(fileURL: URL, queue: DispatchQueue = .main, callback: @escaping () -> Void) {
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

        // Create a Dispatch Source that monitors the file for write operations
        source = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: fileDescriptor,
            eventMask: .delete,
            queue: queue
        )

        source?.setEventHandler {
            callback()
        }

        source?.setCancelHandler {
            close(self.fileDescriptor)
            self.fileDescriptor = -1
            self.source = nil
        }

        // Start monitoring
        source?.resume()
    }

    func stopMonitoring() {
        source?.cancel()
    }
}
