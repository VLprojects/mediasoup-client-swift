import Foundation
import Mediasoup_Private
import WebRTC


public class DataConsumer {
	public weak var delegate: DataConsumerDelegate?

	public var id: String {
		return consumer.id
	}

	public var localId: String {
		return consumer.localId
	}

	public var producerId: String {
		return consumer.producerId
	}

	public var closed: Bool {
		return consumer.closed
	}

	public var label: String {
		return consumer.label
	}

	public var dataProtocol: String {
		return consumer.dataProtocol
	}

	public var appData: String {
		return consumer.appData
	}

	public var sctpStreamParameters: String {
		return consumer.sctpStreamParameters
	}

	private let consumer: DataConsumerWrapper

	internal init(consumer: DataConsumerWrapper) {
		self.consumer = consumer
		consumer.delegate = self
	}

	public func close() {
		consumer.close()
	}
}


extension DataConsumer: DataConsumerWrapperDelegate {
	public func onMessage(_ messageData: Data, consumer: DataConsumerWrapper) {
		guard consumer == self.consumer else {
			return
		}

		self.delegate?.onMessage(data: messageData, from: self)
	}

	public func onConnecting(_ consumer: DataConsumerWrapper) {
		guard consumer == self.consumer else {
			return
		}

		self.delegate?.onConnecting(consumer: self)
	}

	public func onOpen(_ consumer: DataConsumerWrapper) {
		guard consumer == self.consumer else {
			return
		}

		self.delegate?.onOpen(consumer: self)
	}

	public func onClosing(_ consumer: DataConsumerWrapper) {
		guard consumer == self.consumer else {
			return
		}

		self.delegate?.onClosing(consumer: self)
	}

	public func onClose(_ consumer: DataConsumerWrapper) {
		guard consumer == self.consumer else {
			return
		}

		self.delegate?.onClose(consumer: self)
	}

	public func onTransportClose(_ consumer: DataConsumerWrapper) {
		guard consumer == self.consumer else {
			return
		}

		self.delegate?.onTransportClose(in: self)
	}
}
