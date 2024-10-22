// swift-tools-version:5.10

import PackageDescription

let package = Package(
    name: "EIP20Kit",
    platforms: [
        .iOS(.v14),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "EIP20Kit",
            targets: ["EIP20Kit"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/attaswift/BigInt.git", from: "5.4.1"),
        .package(url: "https://github.com/groue/GRDB.swift.git", .upToNextMajor(from: "6.29.3")),
        .package(url: "https://github.com/sunimp/EVMKit.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/sunimp/SWCryptoKit.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/sunimp/SWExtensions.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/nicklockwood/SwiftFormat.git", from: "0.54.6"),
    ],
    targets: [
        .target(
            name: "EIP20Kit",
            dependencies: [
                "BigInt",
                "EVMKit",
                "SWCryptoKit",
                "SWExtensions",
                .product(name: "GRDB", package: "GRDB.swift"),
            ]
        ),
    ]
)
