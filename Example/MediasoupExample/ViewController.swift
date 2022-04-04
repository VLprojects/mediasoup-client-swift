import UIKit
import Mediasoup


final class ViewController: UIViewController {
	@IBOutlet var label: UILabel!
	private var device: Device?

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
		DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
			self.device = nil
		}
	}
}
