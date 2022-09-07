import Foundation
import Mediasoup_Private
import WebRTC


public class Consumer {
	public weak var delegate: ConsumerDelegate?

	public var track: RTCMediaStreamTrack {
		return consumer.track
	}

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

	public var paused: Bool {
		return consumer.paused
	}

	public let kind: MediaKind

	public var appData: String {
		return consumer.appData
	}

	public var rtpParameters: String {
		return consumer.rtpParameters
	}

	public var stats: String {
		return consumer.stats
	}

	private let consumer: ConsumerWrapper

	internal init(consumer: ConsumerWrapper, mediaKind: MediaKind) {
		self.consumer = consumer
		self.kind = mediaKind
		consumer.delegate = self
	}

	public func pause() {
		consumer.pause()
	}

	public func resume() {
		consumer.resume()
	}

	public func close() {
		consumer.close()
	}

	func getStats() throws -> String {
		return try consumer.getStats()
	}
}


extension Consumer: ConsumerWrapperDelegate {
	public func onTransportClose(_ consumer: ConsumerWrapper) {
		guard consumer == self.consumer else {
			return
		}

		self.delegate?.onTransportClose(in: self)
	}
}
