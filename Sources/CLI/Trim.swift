import XCTrimCore
import Foundation

func trim(
    at url: URL?,
    options: Set<PlatformOptions>,
    trimmer: Trimmer = .default(),
    loader: XCFrameworkLoader = .default(),
    fileHandler: FileHandler = .default
) async {
    let url = url ?? fileHandler.currentPath()
    do {
        let xcframeworks = try await loader.load(url)

        try await xcframeworks.concurrentForEach { xcframework  in
            print("trimming \(xcframework.name)")
            try await trimmer.trim(xcframework, options)
        }
    } catch {
        print(error)
        exit(EXIT_FAILURE)
    }

    print("done")
    exit(EXIT_SUCCESS)
}
