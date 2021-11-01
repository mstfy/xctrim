public struct PlatformOptions: Hashable {
    public var platform: Platform
    public var architectures: [Architecture]

    public init(platform: Platform, architectures: [Architecture]) {
        self.platform = platform
        self.architectures = architectures
    }
}

