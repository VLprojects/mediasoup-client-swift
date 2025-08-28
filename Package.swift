// swift-tools-version:5.3
import PackageDescription


let version = "0.9.0"
let mediasoupChecksum = "ce70d0d16499a9972c0b627589946a18859552a6de09b97bb507f898e50504a9"
let webrtcChecksum = "d6f5f751ca3aad5ba9e74896ba6e5a4869b3a50ac6def2a069357277d94ea99a"


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
