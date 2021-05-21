// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ZeplinPreviewSwiftUI",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v10_15), .iOS(.v14), .tvOS(.v14), .watchOS(.v7)
        ],
    products: [
        .library(
            name: "ZeplinPreviewSwiftUI",
            targets: ["ZeplinPreviewSwiftUI"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ZeplinPreviewSwiftUI",
            dependencies: [])
    ]
)
