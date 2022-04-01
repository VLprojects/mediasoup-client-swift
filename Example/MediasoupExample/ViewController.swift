import UIKit
import Mediasoup


final class ViewController: UIViewController {
	@IBOutlet var label: UILabel!

	override func viewDidLoad() {
		super.viewDidLoad()


		let device = Device()
		do {
			try device.load(with: "{}")
			label.text = try device.getSCTPCapabilities()
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
	}
}
