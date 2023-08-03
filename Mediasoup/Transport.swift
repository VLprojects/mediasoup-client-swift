import Foundation


public protocol Transport: AnyObject {
	var id: String { get }
	var closed: Bool { get }
	var connectionState: TransportConnectionState { get }
	var appData: String { get }
	var stats: String { get }

	func close()
	func restartICE(with iceParameters: String) throws
	func updateICEServers(_ iceServers: String) throws
}
