public extension Sequence {
    func concurrentMap<T>(_ transform: @escaping (Element) async -> T) async -> [T] {
        var values = [T]()

        await withTaskGroup(of: T.self) { group in
            for element in self {
                group.addTask {
                    await transform(element)
                }
            }

            for await value in group {
                values.append(value)
            }
        }

        return values
    }

    func concurrentMap<T>(_ transform: @escaping (Element) async throws -> T) async throws -> [T] {
        var values = [T]()

        try await withThrowingTaskGroup(of: T.self) { group in
            for element in self {
                group.addTask {
                    try await transform(element)
                }
            }

            for try await value in group {
                values.append(value)
            }
        }

        return values
    }
}

public extension Sequence {
    func concurrentForEach(_ body: @escaping (Element) async -> Void) async {
        await withTaskGroup(of: Void.self) { group in
            for element in self {
                group.addTask {
                    await body(element)
                }
            }

            for await _ in group { }
        }
    }

    func concurrentForEach(_ body: @escaping (Element) async throws -> Void) async throws {
        try await withThrowingTaskGroup(of: Void.self) { group in
            for element in self {
                group.addTask {
                    try await body(element)
                }
            }

            for try await _ in group { }
        }
    }
}

