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

//	public var maxSpatialLayer: UInt8 {
//		return producer.maxSpatialLayer
//	}

	public var appData: String {
		return consumer.appData
	}

	public var rtpParameters: String {
		return consumer.rtpParameters
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

//	func setMaxSpatialLayer(_ layer: UInt8) throws {
//		try producer.setMaxSpatialLayer(layer)
//	}
//
//	func replaceTrack(_ track: RTCMediaStreamTrack) throws {
//		try producer.replaceTrack(track)
//	}

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
