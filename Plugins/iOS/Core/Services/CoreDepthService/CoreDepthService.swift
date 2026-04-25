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
        return  frame.sceneDepth?.confidenceMap
    }
}
