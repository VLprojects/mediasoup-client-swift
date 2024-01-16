// swift-tools-version:5.3
import PackageDescription


let version = "0.7.0"
let mediasoupChecksum = "477062773f0b1e6157bccd814d7f121ddce8084dc682636389eb7acfe756f631"
let webrtcChecksum = "ede4b5f7ab9ef9cfb6e15e60b564ce9ac69d0310d8de458ef18c460287c4165c"


let package = Package(
	name: "Mediasoup-Client-Swift",
	platforms: [
		.iOS(.v14)
	],
	products: [
		.library(
			name: "Mediasoup",
			targets: [
				"Mediasoup",
				"WebRTC"
			]
		)
	],
	dependencies: [
	],
	targets: [
		.binaryTarget(
			name: "Mediasoup",
			url: "https://github.com/VLprojects/mediasoup-client-swift/releases/download/\(version)/Mediasoup.xcframework.zip",
			checksum: mediasoupChecksum
		),
		.binaryTarget(
			name: "WebRTC",
			url: "https://github.com/VLprojects/mediasoup-client-swift/releases/download/\(version)/WebRTC.xcframework.zip",
			checksum: webrtcChecksum
		)
	]
)
