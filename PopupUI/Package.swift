// swift-tools-version: 5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PopupUI",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "PopupUI",
            targets: ["PopupUI"]),
    ],
    targets: [
        .target(
            name: "PopupUI"),
    ]
)
