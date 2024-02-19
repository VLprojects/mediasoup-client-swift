// swift-tools-version:5.3
import PackageDescription


let version = "0.8.1"
let mediasoupChecksum = "d791d60fce826b7efd041c33b8576f0ccefb87c2f31fb216431b7ac294503a0e"
let webrtcChecksum = "6fd8501746d1de14cc2b2aa86d1ea4e081d8ad50ad190c99fb12fdbfdf3257bf"


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
