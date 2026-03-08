// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CAAlertView",
    platforms: [
        .iOS(.v16),
        .macCatalyst(.v16)
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
        )
    ]
)
