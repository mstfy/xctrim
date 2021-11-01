import Foundation

public struct Trimmer {
    public var trim: (XCFramework, Set<PlatformOptions>) async throws -> Void
}

public extension Trimmer {
    static func `default`(with lipo: Lipo = .default, fileHandler: FileHandler = .default) -> Trimmer {
        Trimmer { xcframework, options in
            let libraries = try await xcframework.plist.availableLibraries
                .concurrentMap { lib in
                    try handleLibrary(lib, at: xcframework.url, for: options, lipo: lipo)
                }
                .compactMap { $0 }

            try savePlist(
                xcframework.plist,
                at: xcframework.url,
                libraries: libraries,
                fileHandler: fileHandler
            )
        }
    }
}

private func handleLibrary(
    _ library: Library,
    at url: URL,
    for options: Set<PlatformOptions>,
    lipo: Lipo
) throws -> Library? {
    let libraryUrl = url.appendingPathComponent(library.libraryIdentifier)
    if
        let platform = library.platform,
        let option = options.first(where: { $0.platform == platform })
    {
        let (editedLibrary, deletedArchs) = library.edit(with: option.architectures)

        if !deletedArchs.isEmpty {
            let binaryName = library.libraryPath.split(separator: ".").first ?? ""

            let binaryUrl = libraryUrl
                .appendingPathComponent(library.libraryPath)
                .appendingPathComponent(String(binaryName))

            if editedLibrary.supportedArchitectures.count == 1 {
                lipo.thin(editedLibrary.supportedArchitectures.first!, binaryUrl)
            } else {
                lipo.remove(deletedArchs, binaryUrl)
            }

            try FileManager.default
                .moveItem(
                    at: url.appendingPathComponent(library.libraryIdentifier),
                    to: url.appendingPathComponent(editedLibrary.libraryIdentifier)
                )
        }

        return editedLibrary
    } else {
        try FileManager.default.removeItem(at: libraryUrl)
        return nil
    }
}

private func savePlist(_ plist: Plist, at url: URL, libraries: [Library], fileHandler: FileHandler) throws {
    var plist = plist
    plist.availableLibraries = libraries

    let data = try PropertyListEncoder().encode(plist)
    let plistUrl = url.appendingPathComponent("Info.plist")
    try fileHandler.save(plistUrl, data)
}
