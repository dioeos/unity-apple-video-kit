import ARKit

struct CameraIntrinsicsData {
    let fx: Float
    let fy: Float
    let cx: Float
    let cy: Float
    let width: Int
    let height: Int
}

enum ARFramesUtils {
    static func getFrameTimestamp(with frame: ARFrame) -> Double {
        return frame.timestamp
    }

    static func getCameraIntrinsics(with frame: ARFrame) -> CameraIntrinsicsData {
        let intrinsics = frame.camera.intrinsics
        let resolution = frame.camera.imageResolution

        return CameraIntrinsicsData(
            fx: intrinsics.columns.0.x,
            fy: intrinsics.columns.1.y,
            cx: intrinsics.columns.2.x,
            cy: intrinsics.columns.2.y,
            width: Int(resolution.width),
            height: Int(resolution.height)
        )
    }
}
