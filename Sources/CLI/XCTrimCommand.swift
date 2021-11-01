import ArgumentParser
import XCTrimCore
import Foundation

@main
struct XCTrim: ParsableCommand {
    static var configuration: CommandConfiguration {
        .init(
            commandName: "xctrim",
            abstract: "a cli program to thin xcframeworks and save some space in your project source code",
            version: "0.1"
        )
    }

    @Option(help: "folder that contains xcframeworks")
    var path: String?

    @Option var platform: [PlatformOptions]

    func run() throws {
        Task {
            await trim(at: path.map(URL.init(fileURLWithPath:)), options: Set(platform))
        }

        dispatchMain()
    }
}
