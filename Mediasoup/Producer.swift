import Foundation
import Mediasoup_Private


public class Producer {
	public var delegate: ProducerDelegate?

	private let producer: ProducerWrapper

	internal init(producer: ProducerWrapper) {
		self.producer = producer
		producer.delegate = self
	}
}


extension Producer: ProducerWrapperDelegate {
	public func onTransportClose(_ producer: ProducerWrapper) {
		guard producer == self.producer else {
			return
		}

		self.delegate?.onTransportClose(in: self)
	}
}
