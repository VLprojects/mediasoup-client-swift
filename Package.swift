// swift-tools-version:5.3
import PackageDescription


let version = "0.10.2"
let mediasoupChecksum = "a8731734eb22eb487092fda0ff014f76db37cecb057785bd84626c73b5d1934c"
let webrtcChecksum = "8b231ed0339189f6afdd0af21a1058e655f8498281566386d97327d5b4861d8a"


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
