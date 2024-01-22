// swift-tools-version:5.3
import PackageDescription


let version = "0.8.0"
let mediasoupChecksum = "cad81c6d038021ebe98edb5ff8876e658d253f9d4a721d6ba028616cab32a754"
let webrtcChecksum = "b2186d4cc9f940432d4751f56f657d1d571be39470e3061c47cbbd36fc26383d"


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
