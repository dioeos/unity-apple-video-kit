import Foundation
import ARKit
import os.log

@objc public final class Coordinator: NSObject {
    @objc public static let shared = Coordinator()

    private let arProviderService: CoreARProviderService
    private let recorderService: CoreRecorderService
    private let fileService: CoreFileService

    private var isRecording = false
    private var metadataFileURL: URL?
    private var recordingStartTimestamp: Double?

    override private init() {
        self.arProviderService = CoreARProviderService()
        self.recorderService = CoreRecorderService()
        self.fileService = CoreFileService(fileType: .csv)
        super.init()
    }

    @objc public static func attach(_ session: ARSession) {
        shared.arProviderService.attach(session)
    }

    @objc public static func detach() {
        shared.arProviderService.detach()
    }

    @objc public static func startRecording() {
        guard shared.arProviderService.currentSession != nil else {
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

            let fileURL = try shared.fileService.createMetadataFile(
                fileName: timestamp,
                location: mp4FolderDestination
            )
            shared.metadataFileURL = fileURL

            let filename = "\(timestamp).mp4"

            guard let beginningFrame = shared.arProviderService.currentFrame else {
                os_log("[Coordinator] Failed to get beginning frame", type: .error)
                return
            }

            shared.recordingStartTimestamp = ARFramesUtils.getFrameTimestamp(with: beginningFrame)

            if shared.recorderService.startRecording(
                with: beginningFrame,
                mp4Destination: mp4FolderDestination,
                fileName: filename
            ) { shared.isRecording = true }

        } catch {
            os_log("[Coordinator] Failed to prepare recording output: %{public}@", type: .error, error.localizedDescription)
        }
    }

    @objc public static func updateRecording() {
        guard shared.isRecording else { return }
        guard shared.arProviderService.currentSession != nil else {
            os_log("[Coordinator] Cannot update recording: No ARSession attached.", type: .error)
            return
        }

        guard let metadataFileURL = shared.metadataFileURL else {
            os_log("[Coordinator] Cannot append metadata: No metadata file available.", type: .error)
            return
        }

        guard let recordingStartTimestamp = shared.recordingStartTimestamp else {
            os_log("[Coordinator] Cannot append metadata: No recording start timestamp available.", type: .error)
            return
        }

        guard let currFrame = shared.arProviderService.currentFrame else {
            os_log("[Coordinator] Failed to get the current frame", type: .error)
            return
        }

        if shared.recorderService.updateRecording(with: currFrame) {
            let elapsedTime = ARFramesUtils.getFrameTimestamp(with: currFrame) - recordingStartTimestamp
            let timestamp = DateUtils.elapsedTimestampString(from: elapsedTime)

            do {
                try shared.fileService.write(.csvRow(["", timestamp]), to: metadataFileURL)
            } catch {
                os_log("[Coordinator] Failed to append metadata row: %{public}@", type: .error, error.localizedDescription)
            }
        }
    }

    @objc public static func stopRecording() {
        shared.recorderService.stopRecording()
        shared.isRecording = false
        shared.metadataFileURL = nil
        shared.recordingStartTimestamp = nil
    }
}
