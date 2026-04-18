import Foundation

enum DateUtils {
    static func timestampString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        return formatter.string(from: Date())
    }

    static func elapsedTimestampString(from seconds: Double) -> String {
        let clampedSeconds = max(seconds, 0)
        let minutes = Int(clampedSeconds) / 60
        let remainingSeconds = Int(clampedSeconds) % 60
        let milliseconds = Int((clampedSeconds * 1000).truncatingRemainder(dividingBy: 1000))

        return String(format: "%02d:%02d.%03d", minutes, remainingSeconds, milliseconds)
    }
}
