import Foundation
import os.log

public final class CoreCsvService: NSObject {
    public override init() {
        super.init()
    }

    public func writeCsvHeaders(fileURL: URL, headers: [String]) throws {
        let headerLine = headers
            .map(escapeCsvField)
            .joined(separator: ",")
        let csvText = headerLine + "\n"

        try csvText.write(to: fileURL, atomically: true, encoding: .utf8)
    }

    public func appendCsvRow(fileURL: URL, row: [String]) throws {
        let rowLine = row
            .map(escapeCsvField)
            .joined(separator: ",")
        let csvText = rowLine + "\n"

        guard let data = csvText.data(using: .utf8) else {
            throw NSError(
                domain: "CoreCsvService",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Failed to encode CSV row as UTF-8."]
            )
        }

        let handle = try FileHandle(forWritingTo: fileURL)
        defer {
            handle.closeFile()
        }

        handle.seekToEndOfFile()
        handle.write(data)
    }

    private func escapeCsvField(_ value: String) -> String {
        let escaped = value.replacingOccurrences(of: "\"", with: "\"\"")
        let needsQuotes = escaped.contains(",")
            || escaped.contains("\"")
            || escaped.contains("\n")

        return needsQuotes ? "\"\(escaped)\"" : escaped
    }
}
