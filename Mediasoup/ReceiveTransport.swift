import Foundation
import WebRTC
import Mediasoup_Private


public class ReceiveTransport {
	public weak var delegate: ReceiveTransportDelegate?

	private let transport: ReceiveTransportWrapper

	internal init(transport: ReceiveTransportWrapper) {
		self.transport = transport

		transport.delegate = self
	}

	deinit {
		print("ReceiveTransport deallocated")
	}

	public func consume(consumerId: String, producerId: String, kind: MediaKind, rtpParameters: String,
		appData: String?) throws -> Consumer {

		return try convertMediasoupErrors {
			let consumer = try self.transport.createConsumer(
				withId: consumerId,
				producerId: producerId,
				kind: kind.mediaClientValue,
				rtpParameters: rtpParameters,
				appData: appData
			)
			return Consumer(consumer: consumer, mediaKind: kind)
		}
	}

	public func consumeData(
		consumerId: String,
		producerId: String,
		streamId: UInt16,
		label: String,
		protocol protocolName: String?,
		appData: String?
	) throws -> DataConsumer {
		return try convertMediasoupErrors {
			let consumer = try self.transport.createDataConsumer(
				withId: consumerId,
				producerId: producerId,
				streamId: streamId,
				label: label,
				protocol: protocolName,
				appData: appData
			)
			return DataConsumer(consumer: consumer)
		}
	}
}

extension ReceiveTransport: Transport {
	public var id: String {
		return transport.id
	}

	public var closed: Bool {
		return transport.closed
	}

	public var connectionState: TransportConnectionState {
		return TransportConnectionState(stringValue: transport.connectionState) ?? .failed
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

extension ReceiveTransport: ReceiveTransportWrapperDelegate {
	public func onConnect(_ transport: ReceiveTransportWrapper, dtlsParameters: String) {
		guard transport == self.transport else {
			return
		}

		delegate?.onConnect(transport: self, dtlsParameters: dtlsParameters)
	}

	public func onConnectionStateChange(
		_ transport: ReceiveTransportWrapper,
		connectionState: MediasoupClientTransportConnectionState) {

		guard transport == self.transport,
			let state = TransportConnectionState(stringValue: connectionState.rawValue) else {

			return
		}

		delegate?.onConnectionStateChange(transport: self, connectionState: state)
	}
}
