import Foundation
import ARKit
import os.log

public protocol ARSessionObserving {
    var currentSession: ARSession? { get }
    func attachInternal(_ session: ARSession)
    func detachInternal()
}

public final class CoreSessionService: NSObject {
    private let observer: ARSessionObserving

    private var isRecording = false
    private var lastAppendedTimestamp: Double = -1.0

    override private init() {
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
