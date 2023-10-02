// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Giphy",
  platforms: [.iOS(.v14), .macOS(.v11)],
  products: [
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .library(
      name: "Giphy",
      targets: ["Giphy"]
    )
  ],
  dependencies: [
    // Dependencies declare other packages that this package depends on.
    .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.8.0")),
    .package(name: "Core", url: "https://github.com/uwaisalqadri/CoreModule.git", .branch("main")),
    .package(name: "ComposableArchitecture", url: "https://github.com/pointfreeco/swift-composable-architecture.git", .branch("main")),
    .package(name: "TCACoordinators", url: "https://github.com/johnpatrickmorgan/TCACoordinators.git", .branch("main")),
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    .target(
      name: "Giphy",
      dependencies: [
        "Alamofire",
        "Core",
        "ComposableArchitecture",
        "TCACoordinators"
      ]),
    .testTarget(
      name: "GiphyTests",
      dependencies: ["Giphy"]
    )
  ]
)
