// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "xctrim",
    platforms: [.macOS(.v12)],
    products: [
        .executable(name: "xctrim", targets: ["CLI"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.1")
    ],
    targets: [
        .executableTarget(
            name: "CLI",
            dependencies: [
                "XCTrimCore",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .target(name: "XCTrimCore")
    ]
)
