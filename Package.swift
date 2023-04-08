// swift-tools-version:5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

enum PackageData {
    static let packageName = "ParseReport"

    enum Target {
        static let main: String = "ParseReport"
    }

    enum Dependencies {
        static let pathKit: (name: String, package: String) = (name: "PathKit", package: "PathKit")
        static let swiftCSV: (name: String, package: String) = (name: "SwiftCSV", package: "SwiftCSV")
        static let argumentParser: (name: String, package: String) = (name: "ArgumentParser", package: "swift-argument-parser")
    }
}

let package = Package(
    name: PackageData.packageName,
    platforms: [.macOS(.v12)],
    products: [
        .executable(
            name: PackageData.Target.main,
            targets: [PackageData.Target.main]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/kylef/PathKit.git", from: "1.0.1"),
        .package(url: "https://github.com/swiftcsv/SwiftCSV.git", from: "0.8.1"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.2")
    ],
    targets: [
        .executableTarget(
            name: PackageData.Target.main,
            dependencies: [
                .product(name: PackageData.Dependencies.pathKit.name, package: PackageData.Dependencies.pathKit.package),
                .product(name: PackageData.Dependencies.swiftCSV.name, package: PackageData.Dependencies.swiftCSV.package),
                .product(name: PackageData.Dependencies.argumentParser.name, package: PackageData.Dependencies.argumentParser.package),
            ]
        )
    ]
)
