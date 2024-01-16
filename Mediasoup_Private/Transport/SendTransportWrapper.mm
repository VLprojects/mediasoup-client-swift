#import <Foundation/Foundation.h>
#import <Transport.hpp>
#import <WebRTC/RTCMediaStreamTrack.h>
#import <WebRTC/RTCRtpEncodingParameters.h>
#import <peerconnection/RTCConfiguration+Private.h>
#import "SendTransportWrapper.hpp"
#import "SendTransportListenerAdapter.hpp"
#import "SendTransportWrapperDelegate.h"
#import "../MediasoupClientError/MediasoupClientErrorHandler.h"
#import "../Producer/ProducerListenerAdapter.hpp"
#import "../Producer/ProducerWrapper.hpp"


@interface SendTransportWrapper () <SendTransportListenerAdapterDelegate> {
	mediasoupclient::SendTransport *_transport;
	SendTransportListenerAdapter *_listenerAdapter;
}
@end


@implementation SendTransportWrapper

- (instancetype)initWithTransport:(mediasoupclient::SendTransport *_Nonnull)transport
	listenerAdapter:(SendTransportListenerAdapter *_Nonnull)listenerAdapter {

	self = [super init];

	if (self != nil) {
		_transport = (mediasoupclient::SendTransport *)transport;
		_listenerAdapter = listenerAdapter;
		_listenerAdapter->delegate = self;
	}

	return self;
}

- (void)dealloc {
	delete _transport;
	delete _listenerAdapter;
}

#pragma mark - Public methods

- (NSString *_Nonnull)id {
	return [NSString stringWithUTF8String:_transport->GetId().c_str()];
}

- (BOOL)closed {
	return _transport->IsClosed() == true;
}

- (NSString *_Nonnull)connectionState {
	return [NSString stringWithUTF8String:_transport->GetConnectionState().c_str()];
}

- (NSString *_Nonnull)appData {
	return [NSString stringWithUTF8String:_transport->GetAppData().dump().c_str()];
}

- (NSString *_Nonnull)stats {
	return [NSString stringWithUTF8String:_transport->GetStats().dump().c_str()];
}

- (void)close {
	_transport->Close();
}

- (void)restartICE:(NSString *_Nonnull)iceParameters
	error:(out NSError *__autoreleasing _Nullable *_Nullable)error {

	mediasoupTry(^{
		auto iceParametersString = std::string(iceParameters.UTF8String);
		auto iceParametersJSON = nlohmann::json::parse(iceParametersString);
		self->_transport->RestartIce(iceParametersJSON);
	}, error);
}

- (void)updateICEServers:(NSString *_Nonnull)iceServers
	error:(out NSError *__autoreleasing _Nullable *_Nullable)error {

	mediasoupTry(^{
		auto iceServersString = std::string(iceServers.UTF8String);
		auto iceServersJSON = nlohmann::json::parse(iceServersString);
		self->_transport->UpdateIceServers(iceServersJSON);
	}, error);
}

- (ProducerWrapper *_Nullable)createProducerForTrack:(RTCMediaStreamTrack *_Nonnull)mediaTrack
	encoding:(RTCRtpEncodingParameters *_Nonnull)encoding
	scalabilityMode:(NSString *_Nonnull)scalabilityMode
	codecOptions:(NSString *_Nullable)codecOptions
	codec:(NSString *_Nullable)codec
	appData:(NSString *_Nullable)appData
	error:(out NSError *__autoreleasing _Nullable *_Nullable)error {

	return [self createProducerForTrack:mediaTrack encodings:@[encoding] scalabilityMode:scalabilityMode
		codecOptions:codecOptions codec:codec appData:appData error:error];
}

- (ProducerWrapper *_Nullable)createProducerForTrack:(RTCMediaStreamTrack *_Nonnull)mediaTrack
	encodings:(NSArray<RTCRtpEncodingParameters *> *_Nullable)encodings
	codecOptions:(NSString *_Nullable)codecOptions
	codec:(NSString *_Nullable)codec
	appData:(NSString *_Nullable)appData
	error:(out NSError *__autoreleasing _Nullable *_Nullable)error {

	return [self createProducerForTrack:mediaTrack encodings:encodings scalabilityMode:nil
		codecOptions:codecOptions codec:codec appData:appData error:error];
}

- (ProducerWrapper *_Nullable)createProducerForTrack:(RTCMediaStreamTrack *_Nonnull)mediaTrack
	encodings:(NSArray<RTCRtpEncodingParameters *> *_Nullable)encodings
	scalabilityMode:(NSString *_Nullable)scalabilityMode
	codecOptions:(NSString *_Nullable)codecOptions
	codec:(NSString *_Nullable)codec
	appData:(NSString *_Nullable)appData
	error:(out NSError *__autoreleasing _Nullable *_Nullable)error {

	auto listenerAdapter = new ProducerListenerAdapter();

	return mediasoupTryWithResult(^ ProducerWrapper * {
		std::vector<webrtc::RtpEncodingParameters> encodingsVector;
		if (encodings != nullptr) {
			encodingsVector.reserve(encodings.count);
			// Build the equvilent c++ encoding from objective-c encoding
			for (RTCRtpEncodingParameters *encoding in encodings) {
				webrtc::RtpEncodingParameters nativeEncoding;
				nativeEncoding.active = encoding.isActive;

				if (encoding.maxBitrateBps != nil) {
					nativeEncoding.max_bitrate_bps = absl::make_optional(encoding.maxBitrateBps.intValue);
				}
				if (encoding.minBitrateBps != nil) {
					nativeEncoding.min_bitrate_bps = absl::make_optional(encoding.minBitrateBps.intValue);
				}
				if (encoding.maxFramerate != nil) {
					nativeEncoding.max_framerate = absl::make_optional(encoding.maxFramerate.doubleValue);
				}
				if (encoding.numTemporalLayers != nil) {
					nativeEncoding.num_temporal_layers = absl::make_optional(encoding.numTemporalLayers.intValue);
				}
				if (encoding.scaleResolutionDownBy != nil) {
					nativeEncoding.scale_resolution_down_by = absl::make_optional(encoding.scaleResolutionDownBy.doubleValue);
				}
				if (scalabilityMode != nil) {
					nativeEncoding.scalability_mode =
						absl::make_optional(std::string(scalabilityMode.UTF8String));
				}
				encodingsVector.emplace_back(nativeEncoding);
			}
		}

		nlohmann::json codecOptionsJson = nlohmann::json::object();
		if (codecOptions != nullptr) {
			codecOptionsJson = nlohmann::json::parse(std::string(codecOptions.UTF8String));
		}

		nlohmann::json *codecJsonPtr = nullptr;
		nlohmann::json codecJson = nlohmann::json::object();
		if (codec != nullptr) {
			codecJson = nlohmann::json::parse(std::string(codec.UTF8String));
			codecJsonPtr = &codecJson;
		}

		nlohmann::json appDataJson = nlohmann::json::object();
		if (appData != nullptr) {
			appDataJson = nlohmann::json::parse(std::string(appData.UTF8String));
		}

		// RTCMediaStreamTrack `hash` returns pointer to native track object.
		auto mediaStreamTrack = (webrtc::MediaStreamTrackInterface *)[mediaTrack hash];

		auto producer = self->_transport->Produce(
			listenerAdapter,
			mediaStreamTrack,
			&encodingsVector,
			&codecOptionsJson,
			codecJsonPtr,
			appDataJson
		);
		return [[ProducerWrapper alloc] initWithProducer:producer mediaStreamTrack:mediaTrack listenerAdapter:listenerAdapter];
	}, ^ void {
		delete listenerAdapter;
	}, error);
}

#pragma mark - SendTransportListenerAdapterDelegate methods

- (void)onConnect:(SendTransportListenerAdapter *_Nonnull)adapter
	dtlsParameters:(NSString *_Nonnull)dtlsParameters {

	if (adapter != _listenerAdapter) {
		return;
	}

	[self.delegate onConnect:self dtlsParameters:dtlsParameters];
}

- (void)onConnectionStateChange:(SendTransportListenerAdapter *_Nonnull)adapter
	connectionState:(NSString *_Nonnull)connectionState {

	if (adapter != _listenerAdapter) {
		return;
	}

	[self.delegate onConnectionStateChange:self connectionState:connectionState];
}

- (void)onProduce:(SendTransportListenerAdapter *_Nonnull)adapter
	kind:(NSString *_Nonnull)kind
	rtpParameters:(NSString *_Nonnull)rtpParameters
	appData:(NSString *_Nonnull)appData
	callback:(void(^_Nonnull)(NSString *_Nullable))callback {

	if (adapter != _listenerAdapter) {
		return;
	}

	[self.delegate onProduce:self kind:kind rtpParameters:rtpParameters appData:appData
		callback:callback];
}

- (void)onProduceData:(SendTransportListenerAdapter *_Nonnull)adapter
	sctpParameters:(NSString *_Nonnull)sctpParameters
	label:(NSString *_Nonnull)label
	protocol:(NSString *_Nonnull)protocol
	appData:(NSString *_Nonnull)appData
	callback:(void(^_Nonnull)(NSString *_Nullable))callback {

	if (adapter != _listenerAdapter) {
		return;
	}

	[self.delegate onProduceData:self sctpParameters:sctpParameters label:label protocol:protocol
		appData:appData callback:callback];
}

@end
