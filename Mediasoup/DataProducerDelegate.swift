import Foundation


public protocol DataProducerDelegate: AnyObject {
	/// Executed when the underlying DataChannel is open.
	func onOpen(in producer: DataProducer)

	/// Executed when the underlying DataChannel is closed for unknown reasons.
	func onClose(in producer: DataProducer)

	/// Executed when the DataChannel buffered amount of bytes changes.
	func onBufferedAmountChange(in producer: DataProducer, dataSize: UInt64);

	/// Executed when the transport this producer belongs to is closed for whatever reason.
	/// The producer itself is also closed.
	func onTransportClose(in producer: DataProducer)
}
