// swift-tools-version:5.2

//
//  Copyright © 2020 Rosberry. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "Fake",
    platforms: [.macOS(.v10_13)],
    products: [
        .executable(name: "Fake", targets: ["Fake"])
    ],
    dependencies: [
        .package(url: "https://github.com/kylef/PathKit", .upToNextMajor(from: "1.0.1")),
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.2.2")),
        .package(url: "https://github.com/jpsim/Yams.git", .upToNextMajor(from: "5.0.6")),
        .package(url: "https://github.com/tuist/XcodeProj.git", .upToNextMajor(from: "8.10.0")),
    ],
    targets: [
        .target(
            name: "Fake",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "Yams",
                "XcodeProj",
                "PathKit"
        ])
    ]
)
