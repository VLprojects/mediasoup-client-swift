import Foundation
import Mediasoup_Private
import WebRTC


public class Device {
	private let device: DeviceWrapper

	/// Initializes the instance with optional control over the audio session lifecycle.
	///
	/// - Parameter captureAudioSession: When `true`, the initializer immediately
	///   retains the internally managed Audio Device Module (ADM), keeping the
	///   audio session active for the object's lifetime. The session will be
	///   automatically released in `deinit`. When `false`, audio session
	///   management follows WebRTC's default behavior.
	public init(captureAudioSession: Bool = false) {
		self.device = DeviceWrapper(captureAudioSession: captureAudioSession)
	}

	public init(pcFactory: RTCPeerConnectionFactory) {
		self.device = DeviceWrapper(pcFactory: pcFactory)
	}

	/// Explicitly starts the internally managed Audio Device Module (ADM).
	///
	/// By default, WebRTC automatically starts and stops the RTCAudioSession and ADM
	/// when audio tracks are created or removed from a channel. Calling this method
	/// ensures the ADM remains active for the entire call duration, which often improves
	/// the reliability of audio-related functionality.
	public func retainAudioSession() {
		device.retainAudioSession()
	}

	/// Explicitly stops the internally managed Audio Device Module (ADM).
	public func releaseAudioSession() {
		device.releaseAudioSession()
	}

	public func isLoaded() -> Bool {
		return device.isLoaded()
	}

	public func load(with routerRTPCapabilities: String) throws {
		try convertMediasoupErrors {
			try device.load(with: routerRTPCapabilities)
		}
	}

	public func rtpCapabilities() throws -> String {
		try convertMediasoupErrors {
			try device.rtpCapabilities()
		}
	}

	public func sctpCapabilities() throws -> String {
		try convertMediasoupErrors {
			try device.sctpCapabilities()
		}
	}

	public func canProduce(_ mediaKind: MediaKind) throws -> Bool {
		try convertMediasoupErrors {
			try device.canProduce(mediaKind.mediaClientValue)
		}
	}

	public func createSendTransport(id: String, iceParameters: String, iceCandidates: String,
		dtlsParameters: String, sctpParameters: String?, iceServers: String? = nil,
		iceTransportPolicy: ICETransportPolicy = .all, appData: String?) throws -> SendTransport {

		return try convertMediasoupErrors {
			let transport = try device.createSendTransport(withId: id, iceParameters: iceParameters,
				iceCandidates: iceCandidates, dtlsParameters: dtlsParameters, sctpParameters: sctpParameters,
				iceServers: iceServers, iceTransportPolicy: iceTransportPolicy.rtcICETransportPolicy,
				appData: appData)

			return SendTransport(transport: transport)
		}
	}

	public func createReceiveTransport(id: String, iceParameters: String, iceCandidates: String,
		dtlsParameters: String, sctpParameters: String? = nil, iceServers: String? = nil,
		iceTransportPolicy: ICETransportPolicy = .all, appData: String? = nil) throws -> ReceiveTransport {

		return try convertMediasoupErrors {
			let transport = try device.createReceiveTransport(withId: id, iceParameters: iceParameters,
				iceCandidates: iceCandidates, dtlsParameters: dtlsParameters, sctpParameters: sctpParameters,
				iceServers: iceServers, iceTransportPolicy: iceTransportPolicy.rtcICETransportPolicy,
				appData: appData)

			return ReceiveTransport(transport: transport)
		}
	}
}
