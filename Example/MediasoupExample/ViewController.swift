import UIKit
import Mediasoup


final class ViewController: UIViewController {
	@IBOutlet var label: UILabel!
	private var device: Device?
	private var sendTransport: SendTransport?

	override func viewDidLoad() {
		super.viewDidLoad()

		let device = Device()
		do {
			print("isLoaded: \(device.isLoaded())")

			try device.load(with: "{}")
			print("isLoaded: \(device.isLoaded())")

			let canProduceVideo = try device.canProduce(.video)
			print("can produce video: \(canProduceVideo)")

			let canProduceAudio = try device.canProduce(.audio)
			print("can produce audio: \(canProduceAudio)")

			let sctpCapabilities = try device.sctpCapabilities()
			print("SCTP capabilities: \(sctpCapabilities)")

			let rtpCapabilities = try device.rtpCapabilities()
			print("RTP capabilities: \(rtpCapabilities)")

			let sendTransport = try device.createSendTransport(
				id: TestData.SendTransport.transportId,
				iceParameters: TestData.SendTransport.iceParameters,
				iceCandidates: TestData.SendTransport.iceCandidates,
				dtlsParameters: TestData.SendTransport.dtlsParameters,
				sctpParameters: nil,
				appData: nil)
			sendTransport.delegate = self
			self.sendTransport = sendTransport

			print("transport id: \(sendTransport.id)")
			print("transport is closed: \(sendTransport.closed)")

			try sendTransport.updateICEServers("[]")
			print("ICE servers updated")

			try sendTransport.restartICE(with: "{}")
			print("ICE restarted")

			sendTransport.close()
			print("transport is closed: \(sendTransport.closed)")

			label.text = "OK"
		} catch let error as MediasoupError {
			switch error {
				case let .unsupported(message):
					label.text = "unsupported: \(message)"
				case let .invalidState(message):
					label.text = "invalid state: \(message)"
				case let .invalidParameters(message):
					label.text = "invalid parameters: \(message)"
				case let .mediasoup(underlyingError):
					label.text = "mediasoup: \(underlyingError)"
				case .unknown(let underlyingError):
					label.text = "unknown: \(underlyingError)"
				@unknown default:
					label.text = "unknown"
			}
		} catch {
			label.text = error.localizedDescription
		}

		self.device = device
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
			self.sendTransport = nil
			print("send transport deallocated")
			self.device = nil
			print("device deallocated")
		}
	}
}


extension ViewController: SendTransportDelegate {
	func onProduce(transport: Transport, kind: String, rtpParameters: String, appData: String,
		callback: @escaping (String?) -> Void) {

		print("on produce \(kind)")
	}

	func onProduceData(transport: Transport, sctpParameters: String, label: String,
		protocol dataProtocol: String, appData: String, callback: @escaping (String?) -> Void) {

		print("on produce data \(label)")
	}

	func onConnect(transport: Transport) {
		print("on connect")
	}

	func onConnectionStateChange(transport: Transport, connectionState: String) {
		print("on connection state change: \(connectionState)")
	}
}
