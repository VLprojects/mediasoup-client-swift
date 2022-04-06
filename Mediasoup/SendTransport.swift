import Foundation
import Mediasoup_Private


public class SendTransport {
	public weak var delegate: SendTransportDelegate?

	private let transport: SendTransportWrapper

	internal init(transport: SendTransportWrapper) {
		self.transport = transport
	}
}

extension SendTransport: Transport {
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
