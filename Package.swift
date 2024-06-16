// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "webview-youtube-player",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "webview-youtube-player",
            targets: ["webview-youtube-player"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "webview-youtube-player"),
        .testTarget(
            name: "webview-youtube-playerTests",
            dependencies: ["webview-youtube-player"]),
    ]
)
