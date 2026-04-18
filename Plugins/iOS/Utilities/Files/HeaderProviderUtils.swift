public struct HeaderProviderUtils: FileHeaderProviding {
    public init() {}

    public func header(for fileType: FileType) -> String? {
        switch fileType {
        case .csv:
            return "frame,timestamp"
        case .json:
            return "{}"
        case .txt:
            return "--- Generated Metadata Report ---"
        default:
            return ""
        }
    }
}

