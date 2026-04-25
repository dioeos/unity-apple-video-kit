
import Foundation
import ARKit
import os.log

public final class CoreDepthService: NSObject {

    public override init() {
        super.init()
    }

    public func getDepthMap(from frame: ARFrame) -> CVPixelBuffer? {
        os_log("[CoreDepthService] Getting Depth Map", type: .default)
        return frame.sceneDepth?.depthMap
    }

    public func getConfidenceMap(from frame: ARFrame) -> CVPixelBuffer? {
        os_log("[CoreDepthService] Getting Confidence Map", type: .default)
        return frame.sceneDepth?.confidenceMap
    }

    public func writeDepthMap(_ depthMap: CVPixelBuffer, to url: URL) throws {
        try writePixelBufferRaw(depthMap, to: url)
    }

    public func writeConfidenceMap(_ confidenceMap: CVPixelBuffer, to url: URL) throws {
        try writePixelBufferRaw(confidenceMap, to: url)
    }

    private func writePixelBufferRaw(_ pixelBuffer: CVPixelBuffer, to url: URL) throws {
        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly) }

        guard let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer) else {
            throw NSError(domain: "CoreDepthService", code: 1)
        }

        let height = CVPixelBufferGetHeight(pixelBuffer)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
        let byteCount = height * bytesPerRow

        let data = Data(bytes: baseAddress, count: byteCount)
        try data.write(to: url)
    }
}
