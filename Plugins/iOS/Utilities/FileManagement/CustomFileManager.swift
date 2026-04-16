import Foundation

protocol FileManaging {
    func getDocumentsDirectoryURL() throws -> URL
    func createDirectory(at url: URL) throws
}


struct CustomFileManager: FileManaging {
    func getDocumentsDirectoryURL() throws -> URL {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw NSError(domain: "FileManager", code: -1)
        }
        return url
    }

    func createDirectory(at url: URL) throws {
        try FileManager.default.createDirectory(
            at: url,
            withIntermediateDirectories: true,
            attributes: nil
        )
    }
}
