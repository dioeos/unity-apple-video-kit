import Foundation
import ARKit
import os.log

@objc public final class Coordinator: NSObject {
    @objc public static let shared = Coordinator()

    private let arProviderService: CoreARProviderService
    private let recorderService: CoreRecorderService
    private let fileService: CoreFileService
    private let depthService: CoreDepthService

    private var isRecording = false
    private var metadataFileURL: URL?
    private var imageDataFileURL: URL?
    private var depthDataFileURL: URL?
    private var recordingStartTimestamp: Double?
    private var frameCount = 0

    override private init() {
        self.arProviderService = CoreARProviderService()
        self.recorderService = CoreRecorderService()
        self.fileService = CoreFileService(fileType: .csv)
        self.depthService = CoreDepthService()
        super.init()
    }

    @objc public static func attach(_ session: ARSession) {
        shared.arProviderService.attach(session)
    }

    @objc public static func detach() {
        shared.arProviderService.detach()
    }


    @objc(startRecordingWithPose:)
    public static func startRecording(with pose: ARCameraPoseBox) {
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

            shared.metadataFileURL = try shared.fileService.createMetadataFile(
                fileName: timestamp,
                location: mp4FolderDestination,
                headers: "frame_id,timestamp,image_path,depth_path,tx,ty,tz,qx,qy,qz,qw"
            )

            shared.depthDataFileURL = try shared.fileService.createMetadataFile(
                fileName: "Depth_Data",
                location: mp4FolderDestination,
                headers: "depth_map,confidence_map"
            )

            shared.imageDataFileURL = try shared.fileService.createMetadataFile(
                fileName: "Image_Data",
                location: mp4FolderDestination,
                headers: "r,g,b"
            )

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
            ) {
                shared.isRecording = true
                let elapsedTime = ARFramesUtils.getFrameTimestamp(with: beginningFrame) - shared.recordingStartTimestamp!
                let timestamp = DateUtils.elapsedTimestampString(from: elapsedTime)
                shared.frameCount += 1

                let depthMap: CVPixelBuffer? = shared.depthService.getDepthMap(from: beginningFrame)
                let confidenceMap: CVPixelBuffer? = shared.depthService.getConfidenceMap(from: beginningFrame)

                try shared.fileService.write(.csvRow([
                    String(shared.frameCount),
                    timestamp,
                    shared.imageDataFileURL?.path ?? "",
                    shared.depthDataFileURL?.path ?? "",
                    String(pose.tx),
                    String(pose.ty),
                    String(pose.tz),
                    String(pose.qx),
                    String(pose.qy),
                    String(pose.qz),
                    String(pose.qw)
                ]), to: shared.metadataFileURL!)

            }

        } catch {
            os_log("[Coordinator] Failed to prepare recording output: %{public}@", type: .error, error.localizedDescription)
        }
    }

    @objc(updateRecordingWithPose:)
    public static func updateRecording(with pose: ARCameraPoseBox) {
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
            shared.frameCount += 1

// TODO: Should get cameraPose (oreintation and position) from Unity
// TODO: Extract RGB data and create separate file path in dir and CSV points to it
// TODO: Extract Depth data and create separate file path in dir and CSV points to it
            do {
                try shared.fileService.write(.csvRow([
                    String(shared.frameCount),
                    timestamp,
                    "",
                    "",
                    String(pose.tx),
                    String(pose.ty),
                    String(pose.tz),
                    String(pose.qx),
                    String(pose.qy),
                    String(pose.qz),
                    String(pose.qw)
                ]), to: metadataFileURL)
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
