#import <Device.hpp>
#import <api/audio_codecs/builtin_audio_encoder_factory.h>
#import <api/audio_codecs/builtin_audio_decoder_factory.h>
#import <sdk/objc/native/api/audio_device_module.h>
#import <sdk/objc/components/video_codec/RTCDefaultVideoDecoderFactory.h>
#import <sdk/objc/components/video_codec/RTCDefaultVideoEncoderFactory.h>
#import <sdk/objc/native/src/objc_video_encoder_factory.h>
#import <sdk/objc/native/src/objc_video_decoder_factory.h>
#import <peerconnection/RTCPeerConnectionFactory.h>
#import <peerconnection/RTCPeerConnectionFactoryBuilder.h>
#import <peerconnection/RTCPeerConnectionFactory+Private.h>
#import <peerconnection/RTCConfiguration+Private.h>
#import "DeviceWrapper.h"
#import "../MediasoupClientError/MediasoupClientErrorHandler.h"
#import "../Transport/SendTransportWrapper.hpp"
#import "../Transport/SendTransportListenerAdapter.hpp"
#import "../Transport/ReceiveTransportWrapper.hpp"
#import "../Transport/ReceiveTransportListenerAdapter.hpp"


@interface DeviceWrapper() {
	mediasoupclient::Device *_device;
	mediasoupclient::PeerConnection::Options *_pcOptions;
}
@property(nonatomic, strong) RTCPeerConnectionFactory *pcFactory;
@end


@implementation DeviceWrapper

- (instancetype _Nonnull)init {
	auto audioEncoderFactory = webrtc::CreateBuiltinAudioEncoderFactory();
	auto audioDecoderFactory = webrtc::CreateBuiltinAudioDecoderFactory();
	auto videoEncoderFactory = std::make_unique<webrtc::ObjCVideoEncoderFactory>(
		[[RTCDefaultVideoEncoderFactory alloc] init]
	);
	auto videoDecoderFactory = std::make_unique<webrtc::ObjCVideoDecoderFactory>(
		[[RTCDefaultVideoDecoderFactory alloc] init]
	);

	auto pcFactoryBuilder = [[RTCPeerConnectionFactoryBuilder alloc] init];
	[pcFactoryBuilder setAudioEncoderFactory:audioEncoderFactory];
	[pcFactoryBuilder setAudioDecoderFactory:audioDecoderFactory];
	[pcFactoryBuilder setVideoEncoderFactory:std::move(videoEncoderFactory)];
	[pcFactoryBuilder setVideoDecoderFactory:std::move(videoDecoderFactory)];
	[pcFactoryBuilder setAudioDeviceModule:webrtc::CreateAudioDeviceModule()];

	auto pcFactory = [pcFactoryBuilder createPeerConnectionFactory];

	self = [self initWithPCFactory:pcFactory];
	return self;
}

- (instancetype _Nonnull)initWithPCFactory:(RTCPeerConnectionFactory *_Nonnull)pcFactory {
	self = [super init];
	if (self != nil) {
		_device = new mediasoupclient::Device();
		_pcOptions = new mediasoupclient::PeerConnection::Options();
		_pcOptions->factory = pcFactory.nativeFactory.get();
		self.pcFactory = pcFactory;
	}
	return self;
}

- (void)dealloc {
	self.pcFactory = nil;
	delete _pcOptions;
	delete _device;
}

- (BOOL)isLoaded {
	return _device->IsLoaded();
}

- (void)loadWithRouterRTPCapabilities:(NSString *)routerRTPCapabilities
	error:(out NSError *__autoreleasing _Nullable *_Nullable)error {

	mediasoupTry(^{
		auto routerRTPCapabilitiesString = std::string(routerRTPCapabilities.UTF8String);
		auto routerRTPCapabilitiesJSON = nlohmann::json::parse(routerRTPCapabilitiesString);
		self->_device->Load(routerRTPCapabilitiesJSON, self->_pcOptions);
	}, error);
}

- (NSString *_Nullable)sctpCapabilitiesWithError:(out NSError *__autoreleasing _Nullable *_Nullable)error {
	return mediasoupTryWithResult(^ NSString * {
		nlohmann::json const capabilities = self->_device->GetSctpCapabilities();
		return [NSString stringWithCString:capabilities.dump().c_str() encoding:NSUTF8StringEncoding];
	}, nil, error);
}

- (NSString *_Nullable)rtpCapabilitiesWithError:(out NSError *__autoreleasing _Nullable *_Nullable)error {
	return mediasoupTryWithResult(^ NSString * {
		nlohmann::json const capabilities = self->_device->GetRtpCapabilities();
		return [NSString stringWithCString:capabilities.dump().c_str() encoding:NSUTF8StringEncoding];
	}, nil, error);
}

- (BOOL)canProduce:(MediasoupClientMediaKind _Nonnull)mediaKind
	error:(out NSError *__autoreleasing _Nullable *_Nullable)error {

	return mediasoupTryWithBool(^ BOOL {
		return self->_device->CanProduce(std::string([mediaKind UTF8String]));
	}, error);
}

- (SendTransportWrapper *_Nullable)createSendTransportWithId:(NSString *_Nonnull)transportId
	iceParameters:(NSString *_Nonnull)iceParameters
	iceCandidates:(NSString *_Nonnull)iceCandidates
	dtlsParameters:(NSString *_Nonnull)dtlsParameters
	sctpParameters:(NSString *_Nullable)sctpParameters
	iceServers:(NSString *_Nullable)iceServers
	iceTransportPolicy:(RTCIceTransportPolicy)iceTransportPolicy
	appData:(NSString *_Nullable)appData
	error:(out NSError *__autoreleasing _Nullable *_Nullable)error {

	auto pcOptions = [self pcOptionsWithICEServers:iceServers iceTransportPolicy:iceTransportPolicy];
	return [self createSendTransportWithId:transportId iceParameters:iceParameters iceCandidates:iceCandidates
		dtlsParameters:dtlsParameters sctpParameters:sctpParameters pcOptions:&pcOptions appData:appData
		error:error];
}

- (SendTransportWrapper *_Nullable)createSendTransportWithId:(NSString *_Nonnull)transportId
	iceParameters:(NSString *_Nonnull)iceParameters
	iceCandidates:(NSString *_Nonnull)iceCandidates
	dtlsParameters:(NSString *_Nonnull)dtlsParameters
	sctpParameters:(NSString *_Nullable)sctpParameters
	pcOptions:(mediasoupclient::PeerConnection::Options *_Nonnull)pcOptions
	appData:(NSString *_Nullable)appData
	error:(out NSError *__autoreleasing _Nullable *_Nullable)error {

	auto listenerAdapter = new SendTransportListenerAdapter();

	try {
		auto idString = std::string(transportId.UTF8String);
		auto iceParametersString = std::string(iceParameters.UTF8String);
		auto iceParametersJSON = nlohmann::json::parse(iceParametersString);
		auto iceCandidatesString = std::string(iceCandidates.UTF8String);
		auto iceCandidatesJSON = nlohmann::json::parse(iceCandidatesString);
		auto dtlsParametersString = std::string(dtlsParameters.UTF8String);
		auto dtlsParametersJSON = nlohmann::json::parse(dtlsParametersString);

		nlohmann::json sctpParametersJSON;
		if (sctpParameters != nil) {
			auto sctpParametersString = std::string(sctpParameters.UTF8String);
			sctpParametersJSON = nlohmann::json::parse(sctpParametersString);
		}

		nlohmann::json appDataJSON = nlohmann::json::object();
		if (appData != nil) {
			auto appDataString = std::string(appData.UTF8String);
			appDataJSON = nlohmann::json::parse(appDataString);
		}

		auto transport = _device->CreateSendTransport(
			listenerAdapter,
			idString,
			iceParametersJSON,
			iceCandidatesJSON,
			dtlsParametersJSON,
			sctpParametersJSON,
			pcOptions,
			appDataJSON
		);
		auto transportWrapper = [[SendTransportWrapper alloc] initWithTransport:transport listenerAdapter:listenerAdapter];
		return transportWrapper;
	} catch(const std::exception &e) {
		delete listenerAdapter;
		*error = mediasoupError(MediasoupClientErrorCodeInvalidParameters, &e);
		return nil;
	}
}

- (ReceiveTransportWrapper *_Nullable)createReceiveTransportWithId:(NSString *_Nonnull)transportId
	iceParameters:(NSString *_Nonnull)iceParameters
	iceCandidates:(NSString *_Nonnull)iceCandidates
	dtlsParameters:(NSString *_Nonnull)dtlsParameters
	sctpParameters:(NSString *_Nullable)sctpParameters
	iceServers:(NSString *_Nullable)iceServers
	iceTransportPolicy:(RTCIceTransportPolicy)iceTransportPolicy
	appData:(NSString *_Nullable)appData
	error:(out NSError *__autoreleasing _Nullable *_Nullable)error {

	auto pcOptions = [self pcOptionsWithICEServers:iceServers iceTransportPolicy:iceTransportPolicy];
	return [self createReceiveTransportWithId:transportId iceParameters:iceParameters iceCandidates:iceCandidates
		dtlsParameters:dtlsParameters sctpParameters:sctpParameters pcOptions:&pcOptions appData:appData error:error];
}

- (ReceiveTransportWrapper *_Nullable)createReceiveTransportWithId:(NSString *_Nonnull)transportId
	iceParameters:(NSString *_Nonnull)iceParameters
	iceCandidates:(NSString *_Nonnull)iceCandidates
	dtlsParameters:(NSString *_Nonnull)dtlsParameters
	sctpParameters:(NSString *_Nullable)sctpParameters
	pcOptions:(mediasoupclient::PeerConnection::Options *_Nonnull)pcOptions
	appData:(NSString *_Nullable)appData
	error:(out NSError *__autoreleasing _Nullable *_Nullable)error {

	auto listenerAdapter = new ReceiveTransportListenerAdapter();

	try {
		auto idString = std::string(transportId.UTF8String);
		auto iceParametersString = std::string(iceParameters.UTF8String);
		auto iceParametersJSON = nlohmann::json::parse(iceParametersString);
		auto iceCandidatesString = std::string(iceCandidates.UTF8String);
		auto iceCandidatesJSON = nlohmann::json::parse(iceCandidatesString);
		auto dtlsParametersString = std::string(dtlsParameters.UTF8String);
		auto dtlsParametersJSON = nlohmann::json::parse(dtlsParametersString);

		nlohmann::json sctpParametersJSON;
		if (sctpParameters != nil) {
			auto sctpParametersString = std::string(sctpParameters.UTF8String);
			sctpParametersJSON = nlohmann::json::parse(sctpParametersString);
		}

		nlohmann::json appDataJSON = nlohmann::json::object();
		if (appData != nil) {
			auto appDataString = std::string(appData.UTF8String);
			appDataJSON = nlohmann::json::parse(appDataString);
		}

		auto transport = _device->CreateRecvTransport(
			listenerAdapter,
			idString,
			iceParametersJSON,
			iceCandidatesJSON,
			dtlsParametersJSON,
			sctpParametersJSON,
			pcOptions,
			appDataJSON
		);
		auto transportWrapper = [[ReceiveTransportWrapper alloc]
			initWithTransport:transport
			pcFactory:self.pcFactory
			listenerAdapter:listenerAdapter
		];
		return transportWrapper;
	} catch(const std::exception &e) {
		delete listenerAdapter;
		*error = mediasoupError(MediasoupClientErrorCodeInvalidParameters, &e);
		return nil;
	}
}

#pragma MARK - Private methods

- (mediasoupclient::PeerConnection::Options)pcOptionsWithICEServers:(NSString *_Nullable)iceServers
	iceTransportPolicy:(RTCIceTransportPolicy)iceTransportPolicy {

	auto pcOptions = mediasoupclient::PeerConnection::Options(*_pcOptions);
	pcOptions.config.type = [RTCConfiguration nativeTransportsTypeForTransportPolicy:iceTransportPolicy];
	if (iceServers != nil) {
		auto iceServersString = std::string(iceServers.UTF8String);
		auto iceServersJSON = nlohmann::json::parse(iceServersString);
		pcOptions.config.servers.clear();

		// RTCIceServer format is described here: https://developer.mozilla.org/en-US/docs/Web/API/RTCIceServer.
		for (const auto& iceServerDescription : iceServersJSON) {
			webrtc::PeerConnectionInterface::IceServer iceServer;
			if (!iceServerDescription.contains("urls")) {
				continue;
			}
			if (iceServerDescription["urls"].is_string()) {
				iceServer.urls = { iceServerDescription["urls"].get<std::string>() };
			} else if (iceServerDescription["urls"].is_array()) {
				iceServer.urls = iceServerDescription["urls"].get<std::vector<std::string>>();
			} else {
				continue;
			}

			if (iceServerDescription.contains("username")) {
				iceServer.username = iceServerDescription["username"].get<std::string>();
			}
			if (iceServerDescription.contains("credential")) {
				iceServer.password = iceServerDescription["credential"].get<std::string>();
			}
			pcOptions.config.servers.push_back(iceServer);
		}
	}
	return pcOptions;
}

@end
