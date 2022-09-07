import Foundation
import Mediasoup_Private
import WebRTC


public class Producer {
	public weak var delegate: ProducerDelegate?

	public var track: RTCMediaStreamTrack {
		return producer.track
	}

	public var id: String {
		return producer.id
	}

	public var localId: String {
		return producer.localId
	}

	public var closed: Bool {
		return producer.closed
	}

	public var paused: Bool {
		return producer.paused
	}

	public let kind: MediaKind

	public var maxSpatialLayer: UInt8 {
		return producer.maxSpatialLayer
	}

	public var appData: String {
		return producer.appData
	}

	public var rtpParameters: String {
		return producer.rtpParameters
	}

	public var stats: String {
		return producer.stats
	}

	private let producer: ProducerWrapper

	internal init(producer: ProducerWrapper, mediaKind: MediaKind) {
		self.producer = producer
		self.kind = mediaKind
		producer.delegate = self
	}

	public func pause() {
		producer.pause()
	}

	public func resume() {
		producer.resume()
	}

	public func close() {
		producer.close()
	}

	public func setMaxSpatialLayer(_ layer: Int) throws {
		guard let typedLayer = UInt8(exactly: layer) else {
			throw MediasoupError.invalidParameters("Layer index can not be negative")
		}
		try producer.setMaxSpatialLayer(typedLayer)
	}

	public func replaceTrack(_ track: RTCMediaStreamTrack) throws {
		try producer.replaceTrack(track)
	}

	public func getStats() throws -> String {
		return try producer.getStats()
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
