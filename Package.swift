// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "WaterfallGrids",
  platforms: [.iOS(.v14), .macOS(.v11), .watchOS(.v7), .visionOS(.v1), .tvOS(.v14)],
  products: [
    .library(
      name: "WaterfallGrids",
      targets: ["WaterfallGrids"]),
  ],
  targets: [
    .target(
      name: "WaterfallGrids"),
  ]
)
