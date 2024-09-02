// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "Eip20Kit",
    platforms: [
        .iOS(.v14),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "Eip20Kit",
            targets: ["Eip20Kit"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/attaswift/BigInt.git", from: "5.4.1"),
        .package(url: "https://github.com/groue/GRDB.swift.git", .upToNextMajor(from: "6.29.2")),
        .package(url: "https://github.com/sunimp/EvmKit.Swift.git", .upToNextMajor(from: "2.2.0")),
        .package(url: "https://github.com/sunimp/WWCryptoKit.Swift.git", .upToNextMajor(from: "1.4.0")),
        .package(url: "https://github.com/sunimp/WWExtensions.Swift.git", .upToNextMajor(from: "1.2.0")),
        .package(url: "https://github.com/nicklockwood/SwiftFormat.git", from: "0.54.3"),
    ],
    targets: [
        .target(
            name: "Eip20Kit",
            dependencies: [
                "BigInt",
                .product(name: "GRDB", package: "GRDB.swift"),
                .product(name: "EvmKit", package: "EvmKit.Swift"),
                .product(name: "WWCryptoKit", package: "WWCryptoKit.Swift"),
                .product(name: "WWExtensions", package: "WWExtensions.Swift"),
            ]
        ),
    ]
)
