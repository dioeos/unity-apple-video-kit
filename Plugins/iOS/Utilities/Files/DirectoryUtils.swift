import Foundation

enum DirectoryUtils {
    static func documentsDirectory() throws -> URL {
        guard let url = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else {
            throw NSError(
                domain: "DirectoryUtils",
                code: 1
            )
        }
        return url
    }
}
