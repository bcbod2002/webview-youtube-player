// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "webview-youtube-player",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "YoutubeWebView",
            targets: ["YoutubeWebView"]
        ),
    ],
    targets: [
        .target(
            name: "YoutubeWebView",
            path: "Sources",
            resources: [.process("Resources/YoutubeIframe.html")],
            publicHeadersPath: "."
        ),
        .testTarget(
            name: "YoutubeWebViewTests",
            dependencies: ["YoutubeWebView"]
        ),
    ]
)
