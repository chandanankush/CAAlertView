// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CAAlertView",
    platforms: [
        .iOS(.v16),
        .macCatalyst(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "CAAlertView",
            targets: ["CAAlertView"]
        )
    ],
    targets: [
        .target(
            name: "CAAlertView",
            path: "Sources/CAAlertView"
        ),
        .executableTarget(
            name: "CAAlertViewDemo",
            dependencies: ["CAAlertView"],
            path: "Sources/CAAlertViewDemo"
        )
    ]
)
