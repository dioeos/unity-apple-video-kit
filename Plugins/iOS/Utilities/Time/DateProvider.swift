import Foundation

protocol DateProviding {
    func now() -> Date
}

struct SystemDateProvider: DateProviding {
    func now() -> Date {
        Date()
    }
}
