import Foundation
import os.log

public enum FileType: String {
    case csv = ".csv"
    case json = ".json"
    case txt = ".txt"
}

public enum FileWritePayload {
    case text(String)
    case json([String: Any])
    case csvRow([String])
}

public protocol A_FileManaging {
    func createFile(fileName: String, fileType: FileType, location: URL) throws -> URL
    func createDirectory(dirName: String, location: URL) throws -> URL
    func write(_ content: String, to url: URL, append: Bool) throws
}

public protocol FileHeaderProviding {
    func header(for fileType: FileType) -> String?
}

// public protocol FileRowProviding {
//     func writeRow(for fileType: FileType)
// }

public final class CoreFileService: NSObject {
    private let headerProvider: FileHeaderProviding
    // private let rowProvider: FileRowProvidiing

    private let fileManager: A_FileManaging
    private let fileType: FileType

    public override init(fileType: FileType) {
        self.fileType = fileType
        self.fileManager = A_FileManager()
        self.headerProvider = HeaderProviderUtils()
        super.init()
    }

    public func createDirectory(dirName: String, location: URL) throws -> URL {
        return try fileManager.createDirectory(dirName: dirName, location: location)
    }

    public func createMetadataFile(fileName: String, location: URL) throws -> URL {
        let fileURL =  try fileManager.createFile(
            fileName: fileName, 
            fileType: self.fileType, 
            location: location
        )

        if let header = headerProvider.header(for: fileType) {
            try fileManager.write(header + "\n", to: fileURL, append: false)
        }

        return fileURL
    }

    public func write(_ payload: FileWritePayload, to fileURL: URL) throws {
        switch (fileType, payload) {
        case (.txt, .text(let text)):
            try fileManager.write(text, to: fileURL, append: true)

        case (.json, .json(let object)):
            let data = try JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted])
            guard let jsonString = String(data: data, encoding: .utf8) else {
                throw NSError(
                    domain: "CoreFileService",
                    code: 1,
                    userInfo: [NSLocalizedDescriptionKey: "Failed to encode JSON as UTF-8."]
                )
            }
            try fileManager.write(jsonString, to: fileURL, append: false)

        case (.csv, .csvRow(let row)):
            let line = row
                .map(Self.escapeCsvField)
                .joined(separator: ",") + "\n"
            try fileManager.write(line, to: fileURL, append: true)

        default:
            throw NSError(
                domain: "CoreFileService",
                code: 2,
                userInfo: [NSLocalizedDescriptionKey: "Payload does not match configured file type \(fileType)."]
            )
        }
    }

    private static func escapeCsvField(_ value: String) -> String {
        let escaped = value.replacingOccurrences(of: "\"", with: "\"\"")
        let needsQuotes = escaped.contains(",") || escaped.contains("\"") || escaped.contains("\n")
        return needsQuotes ? "\"\(escaped)\"" : escaped
    }
}
