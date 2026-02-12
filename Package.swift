// swift-tools-version:5.3
import PackageDescription


let version = "0.10.0"
let mediasoupChecksum = "b4b794b85c7b0ce52f74fd5f6b947e11ef5a57bba2cda1b545122d3766559224"
let webrtcChecksum = "66b9380714dd22c69addc1f956713b31ecd1832b17e66b6645537bfecd4ee551"


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
