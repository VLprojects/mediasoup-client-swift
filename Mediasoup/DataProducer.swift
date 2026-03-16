import Foundation
import Mediasoup_Private
import WebRTC


public class DataProducer {
	public weak var delegate: DataProducerDelegate?

	/// Producer identifier (matches server-side producer id).
	public var id: String {
		return producer.id
	}

	/// Local producer identifier.
	public var localId: String {
		return producer.localId
	}

	/// The SCTP stream parameters.
	public var sctpStreamParameters: String {
		return producer.sctpStreamParameters
	}

	/// The DataChannel ready state.
	public var readyState: DataState {
		switch producer.readyState {
			case .connecting:
				return .connecting
			case .open:
				return .open
			case .closing:
				return .closing
			case .closed:
				return .closed
			@unknown default:
				fatalError("Unrecognized DataState value \(producer.readyState)")
		}
	}

	/// The DataChannel label.
	public var label: String {
		return producer.label
	}

	/// The DataChannel sub-protocol.
	public var `protocol`: String {
		return producer.protocol
	}

	/// The number of bytes of application data (UTF-8 text and binary data)
	/// that have been queued using send().
	public var bufferedAmount: UInt64 {
		return producer.bufferedAmount
	}

	/// Custom data Object provided by the application in the data producer factory method.
	/// The app can modify its content at any time.
	public var appData: String {
		return producer.appData
	}

	/// Whether the producer is closed.
	public var closed: Bool {
		return producer.closed
	}

	private let producer: DataProducerWrapper

	internal init(producer: DataProducerWrapper) {
		self.producer = producer
		producer.delegate = self
	}

	/// Closes the data producer. No more data is transmitted.
	/// This method should be called when the server side data producer has been closed (and vice-versa).
	public func close() {
		producer.close()
	}

	/// Sends the given data over the corresponding DataChannel.
	/// If the data can't be sent at the SCTP level (due to congestion control),
	/// it's buffered at the data channel level, up to a maximum of 16MB.
	/// If Send is called while this buffer is full, the data channel will be closed abruptly.
	///
	/// So, it's important to use GetBufferedAmount and OnBufferedAmountChange to ensure
	/// the data channel is used efficiently but without filling this buffer.
	public func send(_ buffer: Data) {
		producer.send(buffer)
	}
}


extension DataProducer: DataProducerWrapperDelegate {
	public func onOpen(_ producer: DataProducerWrapper) {
		guard producer == self.producer else {
			return
		}

		self.delegate?.onOpen(in: self)
	}

	public func onClose(_ producer: DataProducerWrapper) {
		guard producer == self.producer else {
			return
		}

		self.delegate?.onClose(in: self)
	}

	public func onBufferedAmountChange(_ producer: DataProducerWrapper, dataSize: UInt64) {
		guard producer == self.producer else {
			return
		}

		self.delegate?.onBufferedAmountChange(in: self, dataSize: dataSize)
	}

	public func onTransportClose(_ producer: DataProducerWrapper) {
		guard producer == self.producer else {
			return
		}

		self.delegate?.onTransportClose(in: self)
	}
}
