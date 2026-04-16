import Foundation
import ARKit
import os.log

public protocol A_ARSessionObserving {
    var currentSession: ARSession? { get }
    func attachInternal(_ session: ARSession)
    func detachInternal()
}

public final class CoreSessionService: NSObject {
    private let observer: A_ARSessionObserving

    public var currentSession: ARSession? {
        observer.currentSession
    }

    public override init() {
        self.observer = A_ARSessionObserver()
        super.init()
    }

    public func attach(_ session: ARSession) {
        observer.attachInternal(session)
    }

    public func detach() {
        observer.detachInternal()
    }
}
