// swift-tools-version:5.3
import PackageDescription


let version = "0.13.1"
let mediasoupChecksum = "e9b14ad1b087d61d24cca4587df30909ac60937431597e8314a4b14a7cb1cc56"
let webrtcChecksum = "d4fb371895a5ed86cc1de31a6db72cd87ce661b1ef8c1704c37e9f84ccb3ee7f"


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
