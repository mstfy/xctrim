import ArgumentParser
import XCTrimCore

extension PlatformOptions: ExpressibleByArgument {
    public init?(argument: String) {
        let values = argument.split(separator: " ").map(String.init)
        guard values.count >= 2 else { return nil }

        let platform: Platform
        switch values[0].lowercased() {
        case "ios": platform = .ios
        case "iossimulator": platform = .iosSimulator
        case "ioscatalyst": platform = .iosCatalyst
        case "tvos": platform = .tvOS
        case "tvossimulator": platform = .tvOSSimulator
        case "macos": platform = .macOS
        default: return nil
        }

        let architectures = values.dropFirst()
            .compactMap(Architecture.init(rawValue:))

        guard !architectures.isEmpty else { return nil }

        self.init(platform: platform, architectures: architectures)
    }
}
