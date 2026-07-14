import Foundation


public protocol Transport: AnyObject {
	var id: String { get }
	var closed: Bool { get }
	var connectionState: TransportConnectionState { get }
	var appData: String { get }
	var stats: String { get }

	func close()

	/// This method will dispose (close and deallocate) native transport object.
	/// It can be used for deterministic lifecycle management.
	/// dispose() must be terminate call to the transport object,
	/// any further calls will cause a crash.
	func dispose()

	func restartICE(with iceParameters: String) throws
	func updateICEServers(_ iceServers: String) throws
}
