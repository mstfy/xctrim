import Foundation

public struct FileHandler {
    public var currentPath: () -> URL
    public var moveItem: (URL, URL) throws -> Void
    public var removeItem: (URL) throws -> Void
    public var contents: (URL) throws -> [URL]
    public var load: (URL) throws -> Data
    public var save: (URL, Data) throws -> Void
}

public extension FileHandler {
    static let `default` = FileHandler(
        currentPath: { URL(fileURLWithPath: FileManager.default.currentDirectoryPath) },
        moveItem: { from, to in
            try FileManager.default.moveItem(at: from, to: to)
        },
        removeItem: { itemUrl in
            try FileManager.default.removeItem(at: itemUrl)
        },
        contents: { directoryUrl in
            try FileManager.default.contentsOfDirectory(at: directoryUrl, includingPropertiesForKeys: nil)
        },
        load: { fileUrl in
            try Data(contentsOf: fileUrl)
        },
        save: { fileUrl, data in
            try data.write(to: fileUrl)
        }
    )
}
