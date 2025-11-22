// swift-tools-version: 6.2

import PackageDescription

// IEEE 754: Standard for Floating-Point Arithmetic
//
// Implements IEEE 754-2019 binary floating-point standard
// - IEEE 754-2019: Current standard (published August 2019)
// - IEEE 754-2008: Previous revision
// - IEEE 754-1985: Original standard
//
// This package provides canonical binary serialization for Float and Double
// types following IEEE 754 binary interchange formats.
//
// Pure Swift implementation with no Foundation dependencies,
// suitable for Swift Embedded and constrained environments.

let package = Package(
    name: "swift-ieee-754",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11)
    ],
    products: [
        .library(
            name: "IEEE 754",
            targets: ["IEEE_754"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/swift-standards/swift-standards.git", from: "0.1.0")
    ],
    targets: [
        .target(
            name: "CIEEE754",
            dependencies: []
        ),
        .target(
            name: "IEEE_754",
            dependencies: [
                .product(name: "Standards", package: "swift-standards"),
                .target(name: "CIEEE754", condition: .when(platforms: [.macOS, .linux, .iOS, .tvOS, .watchOS]))
            ]
        ),
        .testTarget(
            name: "IEEE_754".tests,
            dependencies: [
                "IEEE_754",
                .product(name: "StandardsTestSupport", package: "swift-standards")
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)

extension String {
    var tests: Self { self + " Tests" }
}

for target in package.targets where ![.system, .binary, .plugin].contains(target.type) {
    let existing = target.swiftSettings ?? []
    target.swiftSettings = existing + [
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility")
    ]
}
