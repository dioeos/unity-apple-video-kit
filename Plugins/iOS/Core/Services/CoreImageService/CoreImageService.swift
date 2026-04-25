import Foundation
import ARKit
import CoreImage
import ImageIO
import UniformTypeIdentifiers
import os.log

public final class CoreImageService: NSObject {
    private let context: CIContext

    public override init() {
        self.context = CIContext()
        super.init()
    }

    public func writeRGBImage(
        from frame: ARFrame,
        to rgbImagesDirectoryURL: URL,
        frameCount: Int
    ) throws -> URL {
        let fileName = String(format: "rgb_%06d.jpg", frameCount)
        let outputURL = rgbImagesDirectoryURL.appendingPathComponent(fileName)

        let pixelBuffer = frame.capturedImage
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let colorSpace = CGColorSpaceCreateDeviceRGB()

        try context.writeJPEGRepresentation(
            of: ciImage,
            to: outputURL,
            colorSpace: colorSpace,
            options: [
                kCGImageDestinationLossyCompressionQuality as CIImageRepresentationOption: 0.95
            ]
        )

        return outputURL
    }
}
