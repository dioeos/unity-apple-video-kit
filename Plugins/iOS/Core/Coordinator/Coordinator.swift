import Foundation
import ARKit
import os.log

@objc public final class Coordinator: NSObject {
    @objc public static let shared = Coordinator()

    private let sessionService: CoreSessionService
    private let recorderService: CoreRecorderService
    private let fileService: CoreFileService

    private var isRecording = false

    override private init() {
        self.sessionService = CoreSessionService()
        self.recorderService = CoreRecorderService()
        self.fileService = CoreFileService()
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

        do {
            let documentsURL = try DirectoryUtils.documentsDirectory()
            let timestamp = DateUtils.timestampString()

            let mp4FolderDestination = try shared.fileService.createDirectory(
                dirName: timestamp,
                location: documentsURL
            )

            _ = try shared.fileService.createCsvFile(
                fileName: timestamp,
                location: mp4FolderDestination
            )

            let filename = "\(timestamp).mp4"

            shared.recorderService.startRecording(
                with: session,
                mp4Destination: mp4FolderDestination,
                fileName: filename
            )
            
            shared.isRecording = true
        } catch {
            os_log("[Coordinator] Failed to prepare recording output: %{public}@", type: .error, error.localizedDescription)
        }
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
        shared.isRecording = false
    }
}
