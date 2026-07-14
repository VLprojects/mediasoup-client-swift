// swift-tools-version:5.3
import PackageDescription


let version = "0.13.2"
let mediasoupChecksum = "635f6e7f5999508a26d5e723da3f59bbce11f5397a59231a15ce7eca72043e20"
let webrtcChecksum = "b66dd3270a25b93ee3d5804822a012387b493e62267af5c398d88732f7bcd6ff"


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
