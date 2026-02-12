// swift-tools-version:5.3
import PackageDescription


let version = "0.10.1"
let mediasoupChecksum = "8e332f09c77fb2c75a71937536bb1105ed46f6476612e1f54aa90509cfdc9b0d"
let webrtcChecksum = "6dd1667ffb58b7fcc782be1520e9ddcdc59e823b4bbc9e1e276ca40fafc880d4"


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
