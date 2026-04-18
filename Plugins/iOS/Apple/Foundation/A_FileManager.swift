import Foundation
import os.log

public class A_FileManager: A_FileManaging {

    public func createFile(fileName: String, fileType: FileType, location: URL) throws -> URL {
        let fileURL = location.appendingPathComponent(fileName + fileType.rawValue)
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

    public func write(_ content: String, to url: URL, append: Bool) throws {
        guard let data = content.data(using: .utf8) else {
            throw NSError(domain: "A_FileManager", code: 1)
        }

        if append {
            let handle = try FileHandle(forWritingTo: url)
            defer { handle.closeFile() }
            handle.seekToEndOfFile()
            handle.write(data)
        } else {
            try data.write(to: url, options: .atomic)
        }
    }

}
