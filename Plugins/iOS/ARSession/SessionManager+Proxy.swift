import Foundation
import ARKit

extension SessionManager: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame)
    {
        let timestamp = frame.timestamp
        self.updateTimestamp(timestamp)
        print("[SessionManager] Frame timestamp: \(frame.timestamp)")
    }

    func session(_ session: ARSession, didFailWithError error: Error)
    {
        print("[SessionManager] Session failed: \(error.localizedDescription)")
    }

    func sessionWasInterrupted(_ session: ARSession)
    {
        print("[SessionManager] Session interrupted.")
    }

    func sessionInterruptionEnded(_ session: ARSession)
    {
        print("[SessionManager] Session interruption ended.")
    }
}
