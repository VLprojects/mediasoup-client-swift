// swift-tools-version:5.3
import PackageDescription


let version = "0.11.0"
let mediasoupChecksum = "61814bb034b34ced14d5f1e516e15a26c37c7a65d15052dd7cda9d75b4e1805a"
let webrtcChecksum = "462dced7b0e2f1c988842ac01a73829471424eaa690c96809fad54d4d7ff82ad"


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
