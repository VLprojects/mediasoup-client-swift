import Foundation


public protocol ProducerDelegate: AnyObject {
	func onTransportClose(in producer: Producer)
}
