public struct Plist: Codable {
    public var xcFrameworkFormatVersion: String
    public var bundleOSTypeCode: String
    public var availableLibraries: [Library]

    enum CodingKeys: String, CodingKey {
        case xcFrameworkFormatVersion = "XCFrameworkFormatVersion"
        case bundleOSTypeCode = "CFBundlePackageType"
        case availableLibraries = "AvailableLibraries"
    }
}
