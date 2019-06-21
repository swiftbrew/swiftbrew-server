// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "swiftbrew-server",
    products: [
        .library(name: "swiftbrew-server", targets: ["App"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        .package(url: "https://github.com/JustHTTP/Just.git",  .upToNextMajor(from: "0.7.0")),
  ],
    targets: [
        .target(name: "App", dependencies: ["Just", "Vapor"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

