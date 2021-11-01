public enum Platform {
    case ios
    case iosSimulator
    case iosCatalyst
    case tvOS
    case tvOSSimulator
    case macOS
}

extension Platform {
    var supportedArchitectures: Set<Architecture> {
        switch self {
        case .ios:
            return [.arm64, .armv7]
        case .iosSimulator:
            return [.arm64, .i386, .x86_64]
        case .iosCatalyst:
            return [.arm64, .x86_64]
        case .tvOS:
            return [.arm64]
        case .tvOSSimulator:
            return [.arm64, .x86_64]
        case .macOS:
            return [.arm64, .x86_64, .i386]
        }
    }

    func frameworkName(for architectures: Set<Architecture>) -> String {
        let archStr = architectures.sortWithRate()
            .map(\.name)
            .joined(separator: "_")

        switch self {
        case .ios:
            return "ios-\(archStr)"
        case .iosSimulator:
            return "ios-\(archStr)-simulator"
        case .iosCatalyst:
            return "ios-\(archStr)-maccatalyst"
        case .tvOS:
            return "tvos-\(archStr)"
        case .tvOSSimulator:
            return "tvos-\(archStr)-simulator"
        case .macOS:
            return "macos-\(archStr)"
        }
    }
}
