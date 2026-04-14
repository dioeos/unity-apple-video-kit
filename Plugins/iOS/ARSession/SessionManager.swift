import Foundation
import ARKit

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
        guard let frame = shared.session?.currentFrame else {
            return
        }

        do {
            try shared.recorder.start(with: frame)
            shared.isRecording = true
            shared.lastAppendedTimestamp = frame.timestamp
        } catch {
            print("ERROR")
        }
    }

    @objc public static func updateRecording() {
        guard shared.isRecording else { return }
        guard let frame = shared.session?.currentFrame else { return }

        guard frame.timestamp > shared.lastAppendedTimestamp else { return }
        do {
            try shared.recorder.append(frame: frame)
            shared.lastAppendedTimestamp = frame.timestamp
        } catch {
            print("ERROR")
        }
    }

    @objc public static func stopRecording() {
        guard shared.isRecording else { return }

        shared.isRecording = false

        shared.recorder.stop { url, error in
            if let error = error {
                print("[SessionManager] Failed to stop recording: \(error)")
            } else {
                print("[SessionManager] Saved video to: \(url?.path ?? "unknown")")
            }
        }
    }

    @objc public static func getTimestamp() -> Double
    {
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
        print("[SessionManager] Attached to ARSession")
    }

    private func detachInternal()
    {
        session = nil
        print("[SessionManager] Detached from ARSession")
    }
}
