public enum Architecture: String, Codable {
    case arm64
    case i386
    case armv7
    case x86_64
}

public extension Architecture {
    var name: String {
        rawValue
    }

    var sortRate: Int {
        switch self {
        case .arm64:
            return 0
        case .armv7:
            return 1
        case .i386:
            return 2
        case .x86_64:
            return 3
        }
    }
}

extension Sequence where Element == Architecture {
    func sortWithRate() -> [Element] {
        self.sorted { a1, a2 in
            a1.sortRate < a2.sortRate
        }
    }
}
