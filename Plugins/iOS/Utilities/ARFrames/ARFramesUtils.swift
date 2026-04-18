import ARKit

enum ARFramesUtils {
    static func getFrameTimestamp(with frame: ARFrame) -> Double {
        return frame.timestamp
    }
}
