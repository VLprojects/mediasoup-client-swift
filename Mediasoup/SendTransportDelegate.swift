import Foundation


public protocol SendTransportDelegate: AnyObject {
	func onConnect()
	func onConnectionStateChange()
	func onProduce()
}
