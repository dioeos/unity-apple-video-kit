import Foundation
import ARKit
import os.log

public protocol A_ARFramesRecording {
    func startRecording(with session: ARSession)
    func updateRecording(with session: ARSession)
    func stopRecording(completion: @escaping (URL?, Error?) -> Void)
}

public final class CoreRecorderService: NSObject {
    private let frameReader: A_ARFramesRecording

    private var isRecording = false

    override init() {
        self.frameReader = A_ARFramesReader()
        super.init()
    }

    public func startRecording(with session: ARSession) {
        frameReader.startRecording(with: session)
        isRecording = true
    }

    public func updateRecording(with session: ARSession) {
        guard isRecording else { return }
        frameReader.updateRecording(with: session)
    }

    public func stopRecording() {
        guard isRecording else { return }
        isRecording = false
        frameReader.stopRecording { url, error in
            if let error = error {
                os_log("[CoreRecorderService] Error stopping recording: %{public}@", type: .error, error.localizedDescription)
            }
        }
    }
}
