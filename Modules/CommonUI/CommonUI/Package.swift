// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "CommonUI",
  defaultLocalization: "en",
  platforms: [.iOS(.v17), .macOS(.v14)],
  products: [
    .library(
      name: "CommonUI",
      targets: ["CommonUI"])
  ],
  dependencies: [],
  targets: [
    .target(
      name: "CommonUI",
      dependencies: [],
      resources: [
        .process("Assets/LottieFiles/anim_search_empty.json"),
        .process("Assets/LottieFiles/anim_favorite_empty.json"),
        .process("Assets/LottieFiles/anim_nyan_cat.json"),
        .process("Assets/Fonts/Poppins-Bold.ttf"),
        .process("Assets/Fonts/Poppins-SemiBold.ttf"),
        .process("Assets/Fonts/Poppins-Medium.ttf"),
        .process("Assets/Fonts/Poppins-Regular.ttf")
      ]
    ),
    .testTarget(
      name: "CommonUITests",
      dependencies: [.byName(name: "CommonUI")]),
  ]
)
