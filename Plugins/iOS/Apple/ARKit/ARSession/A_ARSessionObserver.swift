import ARKit
import Foundation
import os.log

public class A_ARSessionObserver: A_ARSessionObserving {
    private weak var session: ARSession?

    public init() {}

    public var currentSession: ARSession? {
        return session
    }

    public func attachInternal(_ session: ARSession) {
        self.session = session
        os_log("[ARSessionObserver] Attached to ARSession", type: .default)
    }

    public func detachInternal() {
        self.session = nil
        os_log("[ARSessionObserver] Detached to ARSession", type: .default)
    }
}
