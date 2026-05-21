// swift-tools-version:5.3
import PackageDescription


let version = "0.13.0"
let mediasoupChecksum = "5544d35ebce6942edb22b4664003da02e78fc87766bec6814a9d7e527cac60c1"
let webrtcChecksum = "86b46cdc837626b69feb9e46246fe10a89bb487d72a00ab4854c499ab33cbcab"


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
