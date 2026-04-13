import Foundation
import ARKit

@objc public final class SessionManager : NSObject
{
    @objc public static let shared = SessionManager()

    private weak var session: ARSession?
    private var lastTimestamp: Double = 0.0

    @objc public static func attach(_ session: ARSession)
    {
        shared.attachInternal(session)
    }

    @objc public static func detach()
    {
        shared.detachInternal()
    }

    @objc public static func getTimestamp() -> Double
    {
        return shared.session?.currentFrame?.timestamp ?? 0.0
    }

    private func attachInternal(_ session: ARSession)
    {
        self.session?.delegate = nil
        self.session = session
        print("[SessionManager] Attached to ARSession")
    }

    private func detachInternal()
    {
        session = nil
        print("[SessionManager] Detached from ARSession")
    }
}
