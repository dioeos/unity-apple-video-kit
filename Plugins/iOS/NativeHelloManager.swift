import Foundation
import UIKit

@objc public class NativeHelloManager: NSObject
{
    @objc public static func isBridgeAvailable() -> Bool
    {
        NSLog("[NativeHelloManager] Swift bridge is available.")
        return true
    }

    @objc public static func sayHello() -> String
    {
        return "Hello, World!"
    }
}
