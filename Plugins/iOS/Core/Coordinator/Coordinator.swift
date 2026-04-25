
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

    private var depthFramesDirectoryURL: URL?
    private var confidenceFramesDirectoryURL: URL?

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
        guard shared.arProviderService.currentSession != nil else { return }

        do {
            let documentsURL = try DirectoryUtils.documentsDirectory()
            let timestamp = DateUtils.timestampString()

            let folder = try shared.fileService.createDirectory(
                dirName: timestamp,
                location: documentsURL
            )

            // metadata CSV
            shared.metadataFileURL = try shared.fileService.createMetadataFile(
                fileName: timestamp,
                location: folder,
                headers: "frame_id,timestamp,depth_path,confidence_path,depth_width,depth_height,depth_format,confidence_width,confidence_height,confidence_format,tx,ty,tz,qx,qy,qz,qw"
            )

            // subfolders
            shared.depthFramesDirectoryURL = try shared.fileService.createDirectory(
                dirName: "depth",
                location: folder
            )

            shared.confidenceFramesDirectoryURL = try shared.fileService.createDirectory(
                dirName: "confidence",
                location: folder
            )

            guard let frame = shared.arProviderService.currentFrame else { return }

            shared.recordingStartTimestamp = ARFramesUtils.getFrameTimestamp(with: frame)

            if shared.recorderService.startRecording(
                with: frame,
                mp4Destination: folder,
                fileName: "\(timestamp).mp4"
            ) {
                shared.isRecording = true
                shared.frameCount = 0
                writeFrame(frame: frame, pose: pose)
            }

        } catch {
            os_log("Start recording failed: %{public}@", error.localizedDescription)
        }
    }

    @objc(updateRecordingWithPose:)
    public static func updateRecording(with pose: ARCameraPoseBox) {
        guard shared.isRecording else { return }
        guard let frame = shared.arProviderService.currentFrame else { return }

        if shared.recorderService.updateRecording(with: frame) {
            writeFrame(frame: frame, pose: pose)
        }
    }

    private static func writeFrame(frame: ARFrame, pose: ARCameraPoseBox) {
        guard let metadataFileURL = shared.metadataFileURL else { return }

        shared.frameCount += 1

        let timestamp = DateUtils.elapsedTimestampString(
            from: ARFramesUtils.getFrameTimestamp(with: frame) - shared.recordingStartTimestamp!
        )

        let depthMap = shared.depthService.getDepthMap(from: frame)
        let confidenceMap = shared.depthService.getConfidenceMap(from: frame)

        var depthPath = ""
        var confidencePath = ""

        var depthW = "", depthH = "", depthF = ""
        var confW = "", confH = "", confF = ""

        do {
            if let depthMap,
               let dir = shared.depthFramesDirectoryURL {

                let url = dir.appendingPathComponent("depth_\(shared.frameCount).bin")

                try shared.depthService.writeDepthMap(depthMap, to: url)

                depthPath = url.lastPathComponent
                depthW = String(CVPixelBufferGetWidth(depthMap))
                depthH = String(CVPixelBufferGetHeight(depthMap))
                depthF = String(CVPixelBufferGetPixelFormatType(depthMap))
            }

            if let confidenceMap,
               let dir = shared.confidenceFramesDirectoryURL {

                let url = dir.appendingPathComponent("confidence_\(shared.frameCount).bin")

                try shared.depthService.writeConfidenceMap(confidenceMap, to: url)

                confidencePath = url.lastPathComponent
                confW = String(CVPixelBufferGetWidth(confidenceMap))
                confH = String(CVPixelBufferGetHeight(confidenceMap))
                confF = String(CVPixelBufferGetPixelFormatType(confidenceMap))
            }

            try shared.fileService.write(.csvRow([
                String(shared.frameCount),
                timestamp,

                depthPath,
                confidencePath,

                depthW,
                depthH,
                depthF,

                confW,
                confH,
                confF,

                String(pose.tx),
                String(pose.ty),
                String(pose.tz),
                String(pose.qx),
                String(pose.qy),
                String(pose.qz),
                String(pose.qw)
            ]), to: metadataFileURL)

        } catch {
            os_log("Frame write failed: %{public}@", error.localizedDescription)
        }
    }

    @objc public static func stopRecording() {
        shared.recorderService.stopRecording()
        shared.isRecording = false
        shared.metadataFileURL = nil
    }
}
