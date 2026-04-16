import Foundation
import ARKit
import os.log

@objc public final class Coordinator: NSObject {
    @objc public static let shared = Coordinator()

    private let sessionService: CoreSessionService
    private let recorderService: CoreRecorderService

    private var isRecording = false

    override private init() {
        self.sessionService = CoreSessionService()
        self.recorderService = CoreRecorderService()
        super.init()
    }

    @objc public static func attach(_ session: ARSession) {
        shared.sessionService.attach(session)
    }

    @objc public static func detach() {
        shared.sessionService.detach()
    }

    @objc public static func startRecording() {
        guard let session = shared.sessionService.currentSession else {
            os_log("[Coordinator] Cannot start recording: No ARSession attached.", type: .error)
            return
        }

        shared.recorderService.startRecording(with: session)
    }

    @objc public static func updateRecording() {
        guard shared.isRecording else { return }
        guard let session = shared.sessionService.currentSession else {
            os_log("[Coordinator] Cannot update recording: No ARSession attached.", type: .error)
            return
        }

        shared.recorderService.updateRecording(with: session)
    }

    @objc public static func stopRecording() {
        shared.recorderService.stopRecording()
    }
}
