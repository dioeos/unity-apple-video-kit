import UIKit
import ReplayKit

@objc public class ReplayKitManager: NSObject
{
    private static let recorder = RPScreenRecorder.shared()

    @objc public static func isReplayKitAvailable() -> Bool
    {
        return recorder.isAvailable
    }

    @objc public static func startRecording() -> Bool
    {
        recorder.startRecording { error in
            if let error = error {
                print("Error starting recording: \(error.localizedDescription)")
            } else {
                print("Recording started successfully")
            }
        }

        return true
    }

    @objc public static func stopRecording()
    {
        recorder.stopRecording { previewViewController, error in
            if let error = error {
                print("Error stopping recording: \(error.localizedDescription)")
                return
            }

            guard let previewViewController = previewViewController else {
                print("No preview view controller returned")
                return
            }

            DispatchQueue.main.async {
                guard
                    let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                    let rootVC = scene.windows.first(where: { $0.isKeyWindow })?.rootViewController
                else {
                    print("Could not find root view controller")
                    return
                }

                rootVC.present(previewViewController, animated: true)
            }
        }
    }
}
