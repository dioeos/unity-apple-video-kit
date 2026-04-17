import Foundation
import os.log

public protocol A_FileManaging {
    func createFile(fileName: String, fileType: String, location: URL) throws -> URL
    func createDirectory(dirName: String, location: URL) throws -> URL
}

public final class CoreFileService: NSObject {
    private let fileManager: A_FileManaging

    public override init() {
        self.fileManager = A_FileManager()
        super.init()
    }

    public func createDirectory(dirName: String, location: URL) throws -> URL {
        return try fileManager.createDirectory(dirName: dirName, location: location)
    }

    public func createCsvFile(fileName: String, location: URL) throws -> URL {
        return try fileManager.createFile(fileName: fileName, fileType: ".csv", location: location) 
    }
}
