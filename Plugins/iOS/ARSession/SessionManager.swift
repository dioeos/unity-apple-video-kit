import Foundation
import ARKit
import os.log

@objc public final class SessionManager : NSObject
{
    @objc public static let shared = SessionManager()

    private let recorder = AVWriterManager()
    private var isRecording = false
    private var lastAppendedTimestamp: Double = -1.0
    private weak var session: ARSession?
    private var startTime: Double = 0.0
    private var lastTimestamp: Double = 0.0

    @objc public static func attach(_ session: ARSession)
    {
        shared.attachInternal(session)
        shared.startTime = shared.session?.currentFrame?.timestamp ?? 0.0
    }

    @objc public static func detach()
    {
        shared.detachInternal()
    }

    @objc public static func startRecording() {
        os_log("[SessionManager] start recording!", type: .default)
        guard let frame = shared.session?.currentFrame else {
            return
        }

        do {
            try shared.recorder.start(with: frame)
            shared.isRecording = true
            shared.lastAppendedTimestamp = frame.timestamp
        } catch {
            os_log("[SessionManager] ERROR: %{public}@", type: .error, error.localizedDescription)
        }
    }

    @objc public static func updateRecording() {
        os_log("[SessionManager] update recording!", type: .default)
        guard shared.isRecording else { return }
        guard let frame = shared.session?.currentFrame else { return }

        guard frame.timestamp > shared.lastAppendedTimestamp else { return }
        do {
            try shared.recorder.append(frame: frame)
            shared.lastAppendedTimestamp = frame.timestamp
        } catch {
            os_log("[SessionManager] ERROR: %{public}@", type: .error, error.localizedDescription)
        }
    }

    @objc public static func stopRecording() {
        os_log("[SessionManager] stop recording!", type: .default)
        guard shared.isRecording else { return }

        shared.isRecording = false

        shared.recorder.stop { url, error in
            if let error = error {
                os_log("[SessionManager] Failed to stop recording: %{public}@", type: .error, error.localizedDescription)
            } else {
                os_log("[SessionManager] Saved video to: %{public}@", type: .default, url?.path ?? "unknown")
            }
        }
    }

    @objc public static func getTimestamp() -> Double
    {
        os_log("[SessionManager] Timestamp called", type: .default)
        let elapsed = (shared.session?.currentFrame?.timestamp ?? 0.0) - shared.startTime
        return elapsed
    }

    @objc public static func getPixelBuffer() -> CVPixelBuffer?
    {
        return shared.session?.currentFrame?.capturedImage
    }


    private func attachInternal(_ session: ARSession)
    {
        self.session?.delegate = nil
        self.session = session
        os_log("[SessionManager] Attached to ARSession", type: .default)
    }

    private func detachInternal()
    {
        session = nil
        os_log("[SessionManager] Detached from ARSession", type: .default)
    }
}
