public struct Library: Codable, Equatable {
    public var libraryIdentifier: String
    public var libraryPath: String
    public var supportedArchitectures: Set<Architecture>
    public var supportedPlatform: String
    public var supportedPlatformVariant: String?

    enum CodingKeys: String, CodingKey {
        case libraryIdentifier = "LibraryIdentifier"
        case libraryPath = "LibraryPath"
        case supportedArchitectures = "SupportedArchitectures"
        case supportedPlatform = "SupportedPlatform"
        case supportedPlatformVariant = "SupportedPlatformVariant"
    }

    public func edit(with architectures: [Architecture]) -> (Self, Set<Architecture>) {
        guard let platform = platform else { return (self, []) }

        let supportedArchitectures = platform.supportedArchitectures.intersection(architectures)
        let deletedArchs = self.supportedArchitectures.subtracting(supportedArchitectures)

        var copy = self
        copy.libraryIdentifier = platform.frameworkName(for: supportedArchitectures)
        copy.supportedArchitectures = supportedArchitectures

        return (copy, deletedArchs)
    }
}

public extension Library {
    var platform: Platform? {
        switch (supportedPlatform, supportedPlatformVariant) {
        case ("ios", "simulator"):
            return .iosSimulator
        case ("ios", "maccatalyst"):
            return .iosCatalyst
        case ("ios", nil):
            return .ios
        case ("tvos", "simulator"):
            return .tvOSSimulator
        case ("tvos", nil):
            return .tvOS
        case ("macos", nil):
            return .macOS
        case ("watchos", nil):
            return .watchOS
        case ("watchos", "simulator"):
            return .watchOSSimulator
        default:
            return nil
        }
    }
}
