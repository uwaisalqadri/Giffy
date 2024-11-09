// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Common",
  platforms: [.iOS(.v17), .macOS(.v14)],
  products: [
    .library(
      name: "Common",
      targets: ["Common"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.8.0")),
    .package(url: "https://github.com/uwaisalqadri/CoreModule.git", branch: "main"),
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", branch: "main"),
    .package(url: "https://github.com/alfianlosari/XCAOpenAIClient.git", branch: "main")
  ],
  targets: [
    .target(
      name: "Common",
      dependencies: [
        .byName(name: "Alamofire"),
        .product(name: "Core", package: "CoreModule"),
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .byName(name: "XCAOpenAIClient")
      ]),
    .testTarget(
      name: "CommonTests",
      dependencies: [.byName(name: "Common")]
    )
  ]
)
