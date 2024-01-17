// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "messenger-sdk-ios",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "messenger-sdk-ios",
            targets: ["messenger-sdk-ios"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "messenger-sdk-ios",
            dependencies: [.targetItem(name: "DeskproFramework", condition: .none)],
            path: "Sources"
        ),
        .testTarget(
            name: "messenger-sdk-iosTests",
            dependencies: ["messenger-sdk-ios"]),
        .binaryTarget(
            name: "DeskproFramework",
            path: "Sources/DeskproFramework.xcframework"),
    ]
)
