// swift-tools-version:5.3
import PackageDescription


let version = "0.10.3"
let mediasoupChecksum = "bdbf3f7f7df3e298643a2044e9720b2568dab8b96d9366fecad95ef3352a46f5"
let webrtcChecksum = "8b175c7ed8d85847124b4a0859fee757cf7a970bd026862717664e650522c014"


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
