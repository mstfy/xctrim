import Foundation

public struct XCFrameworkLoader {
    public var load: (URL) async throws -> [XCFramework]
}

public extension XCFrameworkLoader {
    static func `default`(with fileHandler: FileHandler = .default) -> Self {
        XCFrameworkLoader(
            load: { url in
                try await fileHandler.contents(url)
                    .filter { $0.pathExtension == "xcframework" }
                    .concurrentMap { url in
                        try loadXCFramework(at: url)
                    }
            }
        )
    }
}

private func loadXCFramework(at url: URL) throws -> XCFramework {
    let plsitUrl = url.appendingPathComponent("Info.plist")
    let data = try Data(contentsOf: plsitUrl)
    let plist = try PropertyListDecoder().decode(Plist.self, from: data)

    let name = url.lastPathComponent

    return XCFramework(
        name: name,
        url: url,
        plist: plist
    )
}
