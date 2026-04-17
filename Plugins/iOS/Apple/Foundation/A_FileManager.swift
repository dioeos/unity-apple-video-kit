import Foundation
import os.log

public class A_FileManager: A_FileManaging {

    public func createFile(fileName: String, fileType: String, location: URL) throws -> URL {
        let fileURL = location.appendingPathComponent(fileName + fileType)
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            FileManager.default.createFile(atPath: fileURL.path, contents: nil, attributes: nil)
        }
        return fileURL
    }

    public func createDirectory(dirName: String, location: URL) throws -> URL {
        let folderURL = location.appendingPathComponent(dirName)
        try FileManager.default.createDirectory(
            at: folderURL,
            withIntermediateDirectories: true,
            attributes: nil
        )
        return folderURL
    }
}
