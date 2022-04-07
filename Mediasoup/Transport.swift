import Foundation


public protocol Transport {
	var id: String { get }
	var closed: Bool { get }
	var connectionState: String { get }
	var appData: String { get }
	var stats: String { get }

	func close()
	func restartICE(with iceParameters: String) throws
	func updateICEServers(_ iceServers: String) throws
}
