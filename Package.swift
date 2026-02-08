// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Pressure",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "PressureKit",
            targets: ["PressureKit"]
        )
    ],
    targets: [
        .target(
            name: "PressureKit",
            path: "Sources/PressureKit"
        ),
        .testTarget(
            name: "PressureKitTests",
            dependencies: ["PressureKit"],
            path: "Tests/PressureKitTests"
        )
    ]
)
