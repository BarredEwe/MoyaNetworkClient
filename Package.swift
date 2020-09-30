// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "MoyaNC",
    platforms: [.iOS(.v10)],
    products: [
        .library(name: "MoyaNC", targets: ["MoyaNC"]),
        .library(name: "CacheMoyaNC", targets: ["CacheMoyaNC"]),
        .library(name: "FutureMoyaNC", targets: ["FutureMoyaNC"])
    ],
    dependencies: [
        .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "14.0.0")),
    ],
    targets: [
        .target(name: "MoyaNC", dependencies: ["Moya"],
                exclude: ["Example", "fastlane"]),
        .target(name: "CacheMoyaNC", dependencies: ["MoyaNC", "FutureMoyaNC"],
                exclude: ["Example", "fastlane"]),
        .target(name: "FutureMoyaNC", dependencies: ["MoyaNC"],
                exclude: ["Example", "fastlane"])
    ]
)
