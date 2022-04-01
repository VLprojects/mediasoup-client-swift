import Foundation
import Mediasoup_Private


public class Device {
	private let device: DeviceWrapper

	public init() {
		self.device = DeviceWrapper()
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
}
//-(void)load:(NSString *)routerRtpCapabilities;
//-(bool)isLoaded;
//-(NSString *)getRtpCapabilities;
//-(NSString *)getSctpCapabilities;
//-(bool)canProduce:(NSString *)kind;
//-(SendTransport *)createSendTransport:(id<SendTransportListener>)listener id:(NSString *)id iceParameters:(NSString *)iceParameters iceCandidates:(NSString *)iceCandidates dtlsParameters:(NSString *)dtlsParameters;
//-(SendTransport *)createSendTransport:(id<SendTransportListener>)listener id:(NSString *)id iceParameters:(NSString *)iceParameters iceCandidates:(NSString *)iceCandidates dtlsParameters:(NSString *)dtlsParameters sctpParameters:(NSString *)sctpParameters appData:(NSString *)appData;
//-(RecvTransport *)createRecvTransport:(id<RecvTransportListener>)listener id:(NSString *)id iceParameters:(NSString *)iceParameters iceCandidates:(NSString *)iceCandidates dtlsParameters:(NSString *)dtlsParameters;
//-(RecvTransport *)createRecvTransport:(id<RecvTransportListener>)listener id:(NSString *)id iceParameters:(NSString *)iceParameters iceCandidates:(NSString *)iceCandidates dtlsParameters:(NSString *)dtlsParameters sctpParameters:(NSString *)sctpParameters appData:(NSString *)appData;
