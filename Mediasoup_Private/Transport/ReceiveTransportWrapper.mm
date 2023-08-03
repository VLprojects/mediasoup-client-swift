#import <Transport.hpp>
#import <peerconnection/RTCMediaStreamTrack+Private.h>
#import <peerconnection/RTCConfiguration+Private.h>
#import "ReceiveTransportWrapper.hpp"
#import "ReceiveTransportListenerAdapter.hpp"
#import "ReceiveTransportWrapperDelegate.h"
#import "../MediasoupClientError/MediasoupClientErrorHandler.h"
#import "../Consumer/ConsumerListenerAdapter.hpp"
#import "../Consumer/ConsumerWrapper.hpp"
#import "../DataConsumer/DataConsumerListenerAdapter.hpp"
#import "../DataConsumer/DataConsumerWrapper.hpp"


@interface ReceiveTransportWrapper () <ReceiveTransportListenerAdapterDelegate> {
	mediasoupclient::RecvTransport *_transport;
	ReceiveTransportListenerAdapter *_listenerAdapter;
}
@property(nonatomic, strong) RTCPeerConnectionFactory *pcFactory;
@end


@implementation ReceiveTransportWrapper

- (instancetype)initWithTransport:(mediasoupclient::RecvTransport *_Nonnull)transport
	pcFactory:(RTCPeerConnectionFactory *_Nonnull)pcFactory
	listenerAdapter:(ReceiveTransportListenerAdapter *_Nonnull)listenerAdapter {

	self = [super init];

	if (self != nil) {
		_transport = transport;
		_listenerAdapter = listenerAdapter;
		_listenerAdapter->delegate = self;

		self.pcFactory = pcFactory;
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

- (ConsumerWrapper *_Nullable)createConsumerWithId:(NSString *_Nonnull)consumerId
	producerId:(NSString *_Nonnull)producerId
	kind:(MediasoupClientMediaKind _Nonnull)kind
	rtpParameters:(NSString *_Nonnull)rtpParameters
	appData:(NSString *_Nullable)appData
	error:(out NSError *__autoreleasing _Nullable *_Nullable)error {

	auto listenerAdapter = new ConsumerListenerAdapter();

	return mediasoupTryWithResult(^ ConsumerWrapper * {
		auto consumerIdString = std::string(consumerId.UTF8String);
		auto producerIdString = std::string(producerId.UTF8String);
		auto kindString = std::string(kind.UTF8String);

		auto rtpParametersString = std::string(rtpParameters.UTF8String);
		nlohmann::json rtpParametersJSON = nlohmann::json::parse(rtpParametersString);

		nlohmann::json appDataJSON;
		if (appData == nullptr) {
			appDataJSON = nlohmann::json::object();
		} else {
			appDataJSON = nlohmann::json::parse(std::string(appData.UTF8String));
		}

		auto consumer = self->_transport->Consume(
			listenerAdapter,
			consumerIdString,
			producerIdString,
			kindString,
			&rtpParametersJSON,
			appDataJSON
		);

		auto nativeTrack = consumer->GetTrack();
		rtc::scoped_refptr<webrtc::MediaStreamTrackInterface> pTrack(nativeTrack);
		auto track = [RTCMediaStreamTrack mediaTrackForNativeTrack:pTrack factory:self.pcFactory];

		return [[ConsumerWrapper alloc]
			initWithConsumer:consumer
			track:track
			listenerAdapter:listenerAdapter
		];
	}, ^ void {
		delete listenerAdapter;
	}, error);
}

- (DataConsumerWrapper *_Nullable)createDataConsumerWithId:(NSString *_Nonnull)consumerId
	producerId:(NSString *_Nonnull)producerId
	streamId:(UInt16)streamId
	label:(NSString *_Nonnull)label
	protocol:(NSString *_Nullable)protocol
	appData:(NSString *_Nullable)appData
	error:(out NSError *__autoreleasing _Nullable *_Nullable)error
{
	auto listenerAdapter = new DataConsumerListenerAdapter();
	return mediasoupTryWithResult(^ DataConsumerWrapper * {
		auto consumerIdString = std::string(consumerId.UTF8String);
		auto producerIdString = std::string(producerId.UTF8String);
		auto labelString = std::string(label.UTF8String);

		std::string protocolString;
		if (protocol == nil) {
			protocolString = std::string();
		} else {
			protocolString = std::string(protocol.UTF8String);
		}

		nlohmann::json appDataJSON;
		if (appData == nullptr) {
			appDataJSON = nlohmann::json::object();
		} else {
			appDataJSON = nlohmann::json::parse(std::string(appData.UTF8String));
		}

		auto consumer = self->_transport->ConsumeData(
			listenerAdapter,
			consumerIdString,
			producerIdString,
			streamId,
			labelString,
			protocolString,
			appDataJSON
		);
		return [[DataConsumerWrapper alloc]
			initWithDataConsumer:consumer
			listenerAdapter:listenerAdapter
		];
	}, ^ void {
		delete listenerAdapter;
	}, error);
}

#pragma mark - ReceiveTransportListenerAdapterDelegate methods

- (void)onConnect:(ReceiveTransportListenerAdapter *_Nonnull)adapter
	dtlsParameters:(NSString *_Nonnull)dtlsParameters {

	if (adapter != _listenerAdapter) {
		return;
	}

	[self.delegate onConnect:self dtlsParameters:dtlsParameters];
}

- (void)onConnectionStateChange:(ReceiveTransportListenerAdapter *_Nonnull)adapter
	connectionState:(NSString *_Nonnull)connectionState {

	if (adapter != _listenerAdapter) {
		return;
	}

	[self.delegate onConnectionStateChange:self connectionState:connectionState];
}

@end
