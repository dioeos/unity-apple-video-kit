import Foundation
import ARKit
import os.log

public class A_ARFramesReader: A_ARFramesRecording {
    private let writerManager = A_AVWriterManager()
    private var lastAppendedTimestamp: Double = -1.0


    public func startRecording(with frame: ARFrame, mp4Destination: URL, fileName: String) -> Bool {
        os_log("[ARFramesReader] startRecording called.", type: .default)
        do {
            try writerManager.start(with: frame, mp4Destination: mp4Destination, fileName: fileName)
            lastAppendedTimestamp = frame.timestamp
        } catch {
            os_log("[ARFramesReader] ERROR: %{public}@", type: .error, error.localizedDescription)
            return false
        }
        return true
    }

    public func updateRecording(with frame: ARFrame) -> Bool {
        os_log("[ARFramesReader] updateRecording called.", type: .default)
        guard frame.timestamp > lastAppendedTimestamp else { return false }

        do {
            try writerManager.append(frame: frame)
            lastAppendedTimestamp = frame.timestamp
        } catch {
            os_log("[SessionManager] ERROR: %{public}@", type: .error, error.localizedDescription)
            return false
        }
        return true
    }

    public func stopRecording(completion: @escaping (URL?, Error?) -> Void) {
        os_log("[ARFramesReader] stopRecording called.", type: .default)

        writerManager.stop { url, error in
            if let error = error {
                os_log("[SessionManager] Failed to stop recording: %{public}@", type: .error, error.localizedDescription)
            } else {
                os_log("[SessionManager] Saved video to: %{public}@", type: .default, url?.path ?? "unknown")
            }
            completion(url, error)
        }
    }
}
