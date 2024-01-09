// swift-tools-version:5.3
import PackageDescription


let version = "0.6.0"
let mediasoupChecksum = "30f275dca53705e8177d953a365dee829eddfe3df35231302b5d67edaf7cbc56"
let webrtcChecksum = "542bbf59b77450aceb1fddd8bb5a60540fb1c9af400dc6565077f18e63c96124"


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
