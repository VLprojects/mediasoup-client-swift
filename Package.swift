// swift-tools-version:5.3
import PackageDescription


let version = "0.12.0"
let mediasoupChecksum = "04055237cfa4cf3229bd8999fbd6e357eda639d69d0f41593c57d24beeeea9c5"
let webrtcChecksum = "9a87aa591a51d46dc8ada0279dc3ba5533584057516f40a0c8fc9651aa77293e"


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
