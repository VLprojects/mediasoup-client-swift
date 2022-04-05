import Foundation
import Mediasoup_Private


public class SendTransport {
	public weak var delegate: SendTransportDelegate?

	private let transport: SendTransportWrapper

	internal init(transport: SendTransportWrapper) {
		self.transport = transport
	}
}

extension SendTransport: SendTransportWrapperDelegate {
	public func onConnect(_ transportId: String!, dtlsParameters: String!) {
		delegate?.onConnect()
	}

	public func onConnectionStateChange(_ transportId: String!, connectionState: String!) {
		delegate?.onConnectionStateChange()
	}

	public func onProduce(_ transportId: String!, kind: String!, rtpParameters: String!, appData: String!, callback: ((String?) -> Void)!) {
		delegate?.onProduce()
	}
}
