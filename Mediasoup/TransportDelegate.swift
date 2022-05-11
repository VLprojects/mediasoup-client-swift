import Foundation


public protocol TransportDelegate: AnyObject {
	func onConnect(transport: Transport, dtlsParameters: String)
	func onConnectionStateChange(transport: Transport, connectionState: TransportConnectionState)
}
