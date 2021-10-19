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
    .package(name: "Realm", url: "https://github.com/realm/realm-cocoa.git", .exact("3.20.0")),
    .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.4.3")),
    .package(url: "https://github.com/tristanhimmelman/ObjectMapper.git", .exact("3.5.1")),
    .package(name: "ObjectMapper+Realm", url: "https://github.com/Jakenberg/ObjectMapper-Realm.git", .branch("master"))
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    .target(
      name: "Giphy",
      dependencies: [
        .product(name: "RealmSwift", package: "Realm"),
        "Alamofire",
        "ObjectMapper",
        "ObjectMapper+Realm"
      ]),
    .testTarget(
      name: "GiphyTests",
      dependencies: ["Giphy"]
    )
  ]
)
