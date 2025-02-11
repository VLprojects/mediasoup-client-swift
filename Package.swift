// swift-tools-version:5.3
import PackageDescription


let version = "0.8.0"
let mediasoupChecksum = "fa999ead73012cfa9385fbfcfe5a7ffc7987ec0fa9c7873d05fd0349ef38493b"
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
