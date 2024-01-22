import Foundation
import Mediasoup_Private
import WebRTC


public class Producer {
	public weak var delegate: ProducerDelegate?

	/// The audio or video track being transmitted.
	public var track: RTCMediaStreamTrack {
		return producer.track
	}

	/// Producer identifier (matches server-side producer id).
	public var id: String {
		return producer.id
	}

	/// Local producer identifier.
	public var localId: String {
		return producer.localId
	}

	/// Whether the producer is closed.
	public var closed: Bool {
		return producer.closed
	}

	/// Whether the producer is paused.
	public var paused: Bool {
		return producer.paused
	}

	/// The media kind ("audio" or "video").
	public let kind: MediaKind

	/// In case of simulcast, this value determines the highest stream (from 0 to N-1) being transmitted. See the `setMaxSpatialLayer` method for more about this.
	public var maxSpatialLayer: UInt8 {
		return producer.maxSpatialLayer
	}

	/// Custom data Object provided by the application in the producer factory method. The app can modify its content at any time.
	public var appData: String {
		return producer.appData
	}

	/// Producer RTP parameters. These parameters are internally built by the library and conform to the syntax and requirements of mediasoup, thus they can be transmitted to the server to invoke transport.produce() with them.
	public var rtpParameters: String {
		return producer.rtpParameters
	}

	/// Gets the local RTP sender statistics by calling getStats() in the underlying RTCRtpSender instance.
	public var stats: String {
		return producer.stats
	}

	private let producer: ProducerWrapper

	internal init(producer: ProducerWrapper, mediaKind: MediaKind) {
		self.producer = producer
		self.kind = mediaKind
		producer.delegate = self
	}

	/// Pauses the producer (no RTP is sent to the server). This method should be called when the server side producer has been paused (and vice-versa).
	public func pause() {
		producer.pause()
	}

	/// Resumes the producer (RTP is sent again to the server). This method should be called when the server side producer has been resumed (and vice-versa).
	public func resume() {
		producer.resume()
	}

	/// Closes the producer. No more media is transmitted. This method should be called when the server side producer has been closed (and vice-versa).
	public func close() {
		producer.close()
	}

	/// In case of simulcast, this method limits the highest RTP stream being transmitted to the server.
	/// - Parameter layer: The index of the entry in encodings representing the highest RTP stream that will be transmitted.
	public func setMaxSpatialLayer(_ layer: Int) throws {
		guard let typedLayer = UInt8(exactly: layer) else {
			throw MediasoupError.invalidParameters("Layer index can not be negative")
		}
		try producer.setMaxSpatialLayer(typedLayer)
	}

	public func updateSenderParameters(_ updater: @escaping (RTPParameters) -> RTPParameters) {
		producer.updateRTPParameters({ oldValue in
			let updatedValue = updater(RTPParameters(from: oldValue))
			return updatedValue.wrappedValue
		})
	}

	/// Replaces the audio or video track being transmitted. No negotiation with the server is needed.
	/// - Parameter track: An audio or video track.
	public func replaceTrack(_ track: RTCMediaStreamTrack) throws {
		try producer.replaceTrack(track)
	}

	/// Gets the local RTP sender statistics by calling getStats() in the underlying RTCRtpSender instance.
	/// - Returns: RTCStatsReport object serialized to JSON. See https://w3c.github.io/webrtc-pc/#dom-rtcstatsreport for format description.
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
