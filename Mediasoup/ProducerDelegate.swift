import Foundation


public protocol ProducerDelegate {
	func onTransportClose(in producer: Producer)
}
