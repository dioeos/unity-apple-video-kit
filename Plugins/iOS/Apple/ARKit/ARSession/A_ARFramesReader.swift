import Foundation
import ARKit
import os.log

public class ARFramesReader: A_ARFramesRecording {
    private let writerManager = A_AVWriterManager()
    // private let documentsManager = A_DocumentsManager()

    private var lastAppendedTimestamp: Double = -1.0


    public func startRecording(with session: ARSession) {
        os_log("[ARFramesReader] startRecording called.", type: .default)
        guard let frame = session.currentFrame else {
            os_log("[ARFramesReader] startRecording failed to get frame", type: .default)
            return
        }

        do {
            try writerManager.start(with: frame)
            lastAppendedTimestamp = frame.timestamp
        } catch {
            os_log("[ARFramesReader] ERROR: %{public}@", type: .error, error.localizedDescription)
        }
    }

    public func updateRecording(with session: ARSession) {
        os_log("[ARFramesReader] updateRecording called.", type: .default)
        guard let frame = session.currentFrame else {
            os_log("[ARFramesReader] updateRecording failed to get frame", type: .default)
            return
        }

        guard frame.timestamp > lastAppendedTimestamp else { return }

        do {
            try writerManager.append(frame: frame)
            lastAppendedTimestamp = frame.timestamp
        } catch {
            os_log("[SessionManager] ERROR: %{public}@", type: .error, error.localizedDescription)
        }
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
