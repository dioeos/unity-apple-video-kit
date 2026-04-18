import Foundation
import ARKit
import os.log

public protocol A_ARSessionObserving {
    var currentSession: ARSession? { get }
    var currentFrame: ARFrame? { get }
    func attachInternal(_ session: ARSession)
    func detachInternal()
}

public final class CoreARProviderService: NSObject {
    private let observer: A_ARSessionObserving

    public override init() {
        self.observer = A_ARSessionObserver()
        super.init()
    }

    public var currentSession: ARSession? {
        observer.currentSession
    }

    public var currentFrame: ARFrame? {
        observer.currentFrame
    }

    public func attach(_ session: ARSession) {
        observer.attachInternal(session)
    }

    public func detach() {
        observer.detachInternal()
    }
}
