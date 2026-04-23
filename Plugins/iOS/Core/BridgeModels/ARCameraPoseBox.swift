import Foundation

@objc(ARCameraPoseBox)
public class ARCameraPoseBox: NSObject {
    @objc public let tx: Float
    @objc public let ty: Float
    @objc public let tz: Float
    @objc public let qx: Float
    @objc public let qy: Float
    @objc public let qz: Float
    @objc public let qw: Float

    @objc public init(tx: Float, ty: Float, tz: Float, qx: Float, qy: Float, qz: Float, qw: Float) {
        self.tx = tx
        self.ty = ty
        self.tz = tz
        self.qx = qx
        self.qy = qy
        self.qz = qz
        self.qw = qw
        super.init()
    }
}
