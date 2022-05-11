import Foundation


public protocol SendTransportDelegate: TransportDelegate {
	func onProduce(
		transport: Transport,
		kind: MediaKind,
		rtpParameters: String,
		appData: String,
		callback: @escaping (String?) -> Void
	)

	func onProduceData(
		transport: Transport,
		sctpParameters: String,
		label: String,
		protocol dataProtocol: String,
		appData: String,
		callback: @escaping (String?) -> Void
	)
}
