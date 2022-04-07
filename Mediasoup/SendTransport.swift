import Foundation
import WebRTC
import Mediasoup_Private


public class SendTransport {
	public weak var delegate: SendTransportDelegate?

	private let transport: SendTransportWrapper

	internal init(transport: SendTransportWrapper) {
		self.transport = transport
	}

	public func createProducer(for track: RTCMediaStreamTrack, encodings: [RTCRtpEncodingParameters]?,
		codecOptions: String?, appData: String?) throws -> Producer {

		return try convertMediasoupErrors {
			let producer = try self.transport.createProducer(for: track, encodings: encodings,
				codecOptions: codecOptions, appData: appData)
			return Producer(producer: producer)
		}
	}
}

extension SendTransport: Transport {
	public var id: String {
		return transport.id
	}

	public var closed: Bool {
		return transport.closed
	}

	public var connectionState: String {
		return transport.connectionState
	}

	public var appData: String {
		return transport.appData
	}

	public var stats: String {
		return transport.stats
	}

	public func close() {
		transport.close()
	}

	public func restartICE(with iceParameters: String) throws {
		try convertMediasoupErrors {
			try transport.restartICE(iceParameters)
		}
	}

	public func updateICEServers(_ iceServers: String) throws {
		try convertMediasoupErrors {
			try transport.updateICEServers(iceServers)
		}
	}
}

extension SendTransport: SendTransportWrapperDelegate {
	public func onConnect(_ transport: SendTransportWrapper, dtlsParameters: String) {
		guard transport == self.transport else {
			return
		}

		delegate?.onConnect(transport: self)
	}

	public func onConnectionStateChange(_ transport: SendTransportWrapper, connectionState: String) {
		guard transport == self.transport else {
			return
		}

		delegate?.onConnectionStateChange(transport: self, connectionState: connectionState)
	}

	public func onProduce(_ transport: SendTransportWrapper, kind: String, rtpParameters: String,
		appData: String, callback: @escaping (String?) -> Void) {

		guard transport == self.transport else {
			return
		}

		delegate?.onProduce(transport: self, kind: kind, rtpParameters: rtpParameters,
			appData: appData, callback: callback)
	}

	public func onProduceData(_ transport: SendTransportWrapper, sctpParameters: String,
		label: String, protocol dataProtocol: String, appData: String, callback: @escaping (String?) -> Void) {

		guard transport == self.transport else {
			return
		}

		delegate?.onProduceData(transport: self, sctpParameters: sctpParameters, label: label,
			protocol: dataProtocol, appData: appData, callback: callback)
	}
}
