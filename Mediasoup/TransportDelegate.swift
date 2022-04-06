import Foundation


public protocol TransportDelegate: AnyObject {
	func onConnect(transport: Transport)
	func onConnectionStateChange(transport: Transport, connectionState: String)
}
