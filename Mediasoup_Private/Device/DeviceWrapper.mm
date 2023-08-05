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
#import "DeviceWrapper.h"
#import "../MediasoupClientError/MediasoupClientErrorHandler.h"
#import "../Transport/SendTransportWrapper.hpp"
#import "../Transport/SendTransportListenerAdapter.hpp"
#import "../Transport/ReceiveTransportWrapper.hpp"
#import "../Transport/ReceiveTransportListenerAdapter.hpp"

//MARK: PeerConnectionOptions Updation imports
#import <sdk/objc/api/peerconnection/RTCConfiguration.h>
#import <sdk/objc/api/peerconnection/RTCIceServer.h>
#import "sdk/objc/api/peerconnection/RTCMediaConstraints.h"

@interface DeviceWrapper() {
	mediasoupclient::Device *_device;
	mediasoupclient::PeerConnection::Options *_pcOptions;
}
@property(nonatomic, strong) RTCPeerConnectionFactory *pcFactory;
@end


@implementation DeviceWrapper

- (instancetype)init {
	self = [super init];
	if (self != nil) {
		_device = new mediasoupclient::Device();

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

		self.pcFactory = [pcFactoryBuilder createPeerConnectionFactory];
		_pcOptions = new mediasoupclient::PeerConnection::Options();
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
        [self createDefaultPeerConnectionOptions];
		self->_device->Load(routerRTPCapabilitiesJSON, self->_pcOptions);
	}, error);
}

- (void)loadWithRouterRTPCapabilities:(NSString *)routerRTPCapabilities peerConnectionOptions:(NSString *)peerConnectionOptions isRelayTransportPolicy:(BOOL)isRelayTransportPolicy  error:(out NSError *__autoreleasing  _Nullable *)error{
    
    mediasoupTry(^{
        auto routerRTPCapabilitiesString = std::string(routerRTPCapabilities.UTF8String);
        auto routerRTPCapabilitiesJSON = nlohmann::json::parse(routerRTPCapabilitiesString);
        
        //Updating Peerconnection options to set ICE servers.
        [self setCustomPeerConnectionOptions:peerConnectionOptions isRelayTransportPolicy:isRelayTransportPolicy];
        
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
			self->_pcOptions,
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
			self->_pcOptions,
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

//MARK: PeerConnectionOptions Updation functions
- (void)createDefaultPeerConnectionOptions {
    _pcOptions->factory = self.pcFactory.nativeFactory.get();
}

- (void)setCustomPeerConnectionOptions: (NSString *) peerConnectionOptions isRelayTransportPolicy:(BOOL)isRelayTransportPolicy {
        
    // Create a C++ vector to store std::string elements
    webrtc::PeerConnectionInterface::IceServers iceVector;

    // Convert and populate the C++ vector from the NSArray
    for (RTC_OBJC_TYPE(RTCIceServer) *iceServer in  [self getIceServerList:peerConnectionOptions]) {
        
        webrtc::PeerConnectionInterface::IceServer ice;
        const char *cUserName = [iceServer.username UTF8String];
        const char *cCredential = [iceServer.credential UTF8String];
        std::string name(cUserName);
        std::string password(cCredential);
      
        ice.username=name;
        ice.password=password;
        
        std::vector<std::string> urlVector;
        urlVector.push_back(std::string ([iceServer.urlStrings.firstObject UTF8String]));
        ice.urls = urlVector;
        
        iceVector.push_back(ice);
    }
    
    RTC_OBJC_TYPE(webrtc::PeerConnectionInterface::RTCConfiguration) config;
    config.servers = iceVector;
    if (isRelayTransportPolicy) {
        config.type = webrtc::PeerConnectionInterface::kRelay;
    }
    _pcOptions->config.servers =  config.servers;
}

- (NSArray<RTC_OBJC_TYPE(RTCIceServer) *> *)getIceServerList:(NSString *)peerConnectionOptions {
    NSMutableArray<RTC_OBJC_TYPE(RTCIceServer) *> *iceServersArray = [NSMutableArray array];

    NSData *jsonData = [peerConnectionOptions dataUsingEncoding:NSUTF8StringEncoding];
    if (jsonData) {
        NSError *error = nil;
        NSArray<NSDictionary *> *dictionariesArray = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (!error) {
            for (NSDictionary *serverDict in dictionariesArray) {
                RTC_OBJC_TYPE(RTCIceServer) *iceServer = [self iceServerFromJSONDictionary:serverDict];
                if (iceServer) {
                    [iceServersArray addObject:iceServer];
                }
            }
        } else {
            NSLog(@"Error parsing JSON: %@", error);
        }
    }
    return iceServersArray;
}

- (RTC_OBJC_TYPE(RTCIceServer *))iceServerFromJSONDictionary:(NSDictionary *)dictionary {
    NSArray<NSString *> *urlStrings = @[dictionary[@"urls"]];
    NSString *username = dictionary[@"username"];
    NSString *credential = dictionary[@"credential"];

    if (urlStrings.count == 0 || username.length == 0 || credential.length == 0) {
        return nil;
    }
    RTC_OBJC_TYPE(RTCIceServer) *iceServer = [[RTC_OBJC_TYPE(RTCIceServer) alloc] initWithURLStrings:urlStrings username:username credential:credential];
    return iceServer;
}

@end
