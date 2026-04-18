import Foundation
import ARKit
import os.log

public protocol A_ARFramesRecording {
    func startRecording(with frame: ARFrame, mp4Destination: URL, fileName: String)
    func updateRecording(with frame: ARFrame)
    func stopRecording(completion: @escaping (URL?, Error?) -> Void)
}

public final class CoreRecorderService: NSObject {
    private let frameReader: A_ARFramesRecording

    private var isRecording = false

    public override init() {
        self.frameReader = A_ARFramesReader()
        super.init()
    }

    public func startRecording(with frame: ARFrame, mp4Destination: URL, fileName: String) {
        frameReader.startRecording(
            with: frame,
            mp4Destination: mp4Destination,
            fileName: fileName
        )
        isRecording = true
    }

    public func updateRecording(with frame: ARFrame) {
        guard isRecording else { return }
        frameReader.updateRecording(with: frame)
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
