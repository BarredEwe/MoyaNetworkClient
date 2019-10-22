// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "MoyaNetworkClient",
    platforms: [.iOS(.v8)],
    products: [
        .library(name: "MoyaNetworkClient", targets: ["MoyaNetworkClient"]),
        // TODO: Add Cache compatibility
//        .library(name: "MoyaNetworkClient+Cache", targets: ["MoyaNetworkClient+Cache"]),
        .library(name: "MoyaNetworkClient+Future", targets: ["MoyaNetworkClient+Future"])
    ],
    dependencies: [
        .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "13.0.0")),
//        .package(url: "https://github.com/hyperoslo/Cache.git", .upToNextMajor(from: "5.2.0"))
    ],
    targets: [
        .target(name: "MoyaNetworkClient", dependencies: ["Moya"],
                exclude: ["Example", "fastlane"]),
//        .target(name: "MoyaNetworkClient+Cache", dependencies: ["MoyaNetworkClient", "Cache"],
//                exclude: ["Example", "fastlane"]),
        .target(name: "MoyaNetworkClient+Future", dependencies: ["MoyaNetworkClient"],
                exclude: ["Example", "fastlane"]),
    ]
)
