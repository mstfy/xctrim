import Foundation

public struct Lipo {
    public var remove: (Set<Architecture>, URL) -> Void
    public var thin: (Architecture, URL) -> Void
}

public extension Lipo {
    static let `default` = Lipo(remove: lipoRemove, thin: lipoThin)
}

private func lipoRemove(archs: Set<Architecture>, at url: URL) {
    let removeCommand = archs.map { "-remove \($0.name)" }
        .joined(separator: " ")

    let file = url.path

    let command = "lipo \(removeCommand) \(file) -o \(file)"
    let _ = shell(command)
}

private func lipoThin(arch: Architecture, at url: URL) {
    let file = url.path

    let command = "lipo -thin \(arch.name) \(file) -o \(file)"
    let _ = shell(command)
}


private func shell(_ command: String) -> String {
    let task = Process()
    let pipe = Pipe()

    task.standardOutput = pipe
    task.standardError = pipe
    task.arguments = ["-c", command]
    task.launchPath = "/bin/zsh"
    task.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!

    return output
}
