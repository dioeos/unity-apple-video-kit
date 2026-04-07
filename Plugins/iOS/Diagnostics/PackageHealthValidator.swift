import UIKit

@objc public class PackageHealthValidator : NSObject
{
    @objc public static func isPackageHealthy() -> Bool
    {
        NSLog("[PackageHealthValidator] Unity Apple Video Kit by Dioeos is healthy! Happy programming")
        return true
    }

    @objc public static func sayHello() -> String
    {
        return "Hello, World!"
    }
}
