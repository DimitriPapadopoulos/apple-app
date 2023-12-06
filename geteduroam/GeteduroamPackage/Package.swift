// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GeteduroamPackage",
    defaultLocalization: "en",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Main",
            targets: ["Main"]),
        .library(
            name: "AuthClient",
            targets: ["AuthClient"]),
        .library(
            name: "Backport",
            targets: ["Backport"]),
        .library(
            name: "CacheClient",
            targets: ["CacheClient"]),
        .library(
            name: "DiscoveryClient",
            targets: ["DiscoveryClient"]),
        .library(
            name: "Connect",
            targets: ["Connect"]),
        .library(
            name: "EAPConfigurator",
            targets: ["EAPConfigurator"]),
        .library(
            name: "HotspotNetworkClient",
            targets: ["HotspotNetworkClient"]),
        .library(
            name: "Models",
            targets: ["Models"]),
        .library(
            name: "NotificationClient",
            targets: ["NotificationClient"]),
    ],
    dependencies: [
        .package(url: "https://github.com/CoreOffice/XMLCoder.git", .upToNextMajor(from: "0.16.0")),
        .package(url: "https://github.com/egeniq/network-ios.git", branch: "main"),
        .package(url: "https://github.com/openid/AppAuth-iOS.git", from: "1.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-custom-dump", from: "1.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.12.0"),
        .package(url: "https://github.com/pointfreeco/swift-url-routing", from: "0.6.0"),
        .package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Main",
            dependencies: [
                "AuthClient",
                "Backport",
                "CacheClient",
                "Connect",
                .product(name: "Dependencies", package: "swift-dependencies"),
                "DiscoveryClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .testTarget(
            name: "MainTests",
            dependencies: ["Main"]),
        .target(
            name: "AuthClient",
            dependencies: [
                .product(name: "AppAuth", package: "AppAuth-iOS"),
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "XCTestDynamicOverlay", package: "xctest-dynamic-overlay")
            ]),
        .target(
            name: "Backport",
            dependencies: []),
        .target(
            name: "CacheClient",
            dependencies: [
                "Models",
                .product(name: "Dependencies", package: "swift-dependencies"),
            ]),
        .target(
            name: "Connect",
            dependencies: [
                "AuthClient",
                "Backport",
                "EAPConfigurator",
                "HotspotNetworkClient",
                "Models",
                "NotificationClient",
                .product(name: "AppAuth", package: "AppAuth-iOS"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]),
        .testTarget(
            name: "ConnectTests",
            dependencies: [
                "Connect",
                .product(name: "MockNetwork", package: "network-ios"),
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ]),
        .target(
            name: "DiscoveryClient",
            dependencies: [
                "Models",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "URLRouting", package: "swift-url-routing")
            ]),
        .target(
            name: "HotspotNetworkClient",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
            ]),
        .target(
            name: "Models",
            dependencies: [
                "XMLCoder"
            ]
        ),
        .testTarget(
            name: "ModelsTests",
            dependencies: [
                "Models",
                .product(name: "CustomDump", package: "swift-custom-dump")
            ]),
        .target(
            name: "EAPConfigurator",
            dependencies: [
                "Models",
                .product(name: "Dependencies", package: "swift-dependencies")
            ]),
        .target(
            name: "NotificationClient",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies")
            ]),
    ]
)
