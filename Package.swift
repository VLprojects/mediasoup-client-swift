// swift-tools-version:5.3
import PackageDescription


let version = "0.10.4"
let mediasoupChecksum = "169fe2c5a1092297727c636771f21d8066a851b5aaefecb824087b988e53ff15"
let webrtcChecksum = "60a7fb73db054ecbd4eedfc545a3129180676c11286738fcd329b65423581ab6"


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
