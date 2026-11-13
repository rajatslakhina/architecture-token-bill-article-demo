// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "ArchitectureTokenBill",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "ArchitectureTokenBill", targets: ["ArchitectureTokenBill"]),
    ],
    targets: [
        .target(name: "ArchitectureTokenBill"),
        .testTarget(name: "ArchitectureTokenBillTests", dependencies: ["ArchitectureTokenBill"]),
    ]
)
