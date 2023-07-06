import Foundation


public protocol DataConsumerDelegate: AnyObject {
	func onConnecting(consumer: DataConsumer)
	func onOpen(consumer: DataConsumer)
	func onClosing(consumer: DataConsumer)
	func onClose(consumer: DataConsumer)
	func onTransportClose(in consumer: DataConsumer)
	func onMessage(data: Data, from consumer: DataConsumer)
}
