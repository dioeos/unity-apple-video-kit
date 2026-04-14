import Foundation
import AVFoundation
import ARKit
import CoreMedia
import CoreVideo

final class AVWriterManager {
    private var writer: AVAssetWriter?
    private var videoInput: AVAssetWriterInput?
    private var adaptor: AVAssetWriterInputPixelBufferAdaptor?
    private var firstTimestamp: TimeInterval?
    private var outputURL: URL?

    func start(with firstFrame: ARFrame) throws {
        let pixelBuffer = firstFrame.capturedImage
        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)

        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = documentsURL.appendingPathComponent("ar_capture.mp4")
        try? FileManager.default.removeItem(at: url)

        let writer = try AVAssetWriter(url: url, fileType: .mp4)

        let settings: [String: Any] = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: width,
            AVVideoHeightKey: height
        ]

        let input = AVAssetWriterInput(mediaType: .video, outputSettings: settings)
        input.expectsMediaDataInRealTime = true

        guard writer.canAdd(input) else {
            throw NSError(domain: "Writer", code: -1)
        }
        writer.add(input)

        let attrs: [String: Any] = [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange,
            kCVPixelBufferWidthKey as String: width,
            kCVPixelBufferHeightKey as String: height
        ]

        let adaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: input, sourcePixelBufferAttributes: attrs)

        guard writer.startWriting() else {
            throw writer.error ?? NSError(domain: "Writer", code: -2)
        }
        writer.startSession(atSourceTime: .zero)

        self.writer = writer
        self.videoInput = input
        self.adaptor = adaptor
        self.outputURL = url
        self.firstTimestamp = firstFrame.timestamp
    }

    func append(frame: ARFrame) throws {
        guard
            let input = videoInput,
            let adaptor = adaptor,
            let firstTimestamp = firstTimestamp
        else { return }

        guard input.isReadyForMoreMediaData else { return }

        let seconds = frame.timestamp - firstTimestamp
        let time = CMTime(seconds: seconds, preferredTimescale: 600)

        if !adaptor.append(frame.capturedImage, withPresentationTime: time) {
            throw writer?.error ?? NSError(domain: "Writer", code: -3)
        }
    }

    func stop(completion: @escaping (URL?, Error?) -> Void) {
        guard let writer = writer, let input = videoInput, let url = outputURL else {
            completion(nil, nil)
            return
        }

        input.markAsFinished()
        writer.finishWriting {
            if writer.status == .completed {
                completion(url, nil)
            } else {
                completion(nil, writer.error)
            }
        }
    }
}
