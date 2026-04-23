public struct HeaderProviderUtils: FileHeaderProviding {
    public init() {}

    public func header(for fileType: FileType) -> String? {
        switch fileType {
        case .csv:
            return "frame_id,timestamp,image_path,depth_path,tx,ty,tz,qx,qy,qz,qw"
        case .json:
            return "{}"
        case .txt:
            return "--- Generated Metadata Report ---"
        default:
            return ""
        }
    }
}

