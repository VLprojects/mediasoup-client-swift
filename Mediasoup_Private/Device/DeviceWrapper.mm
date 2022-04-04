#import <Device.hpp>
#import <peerconnection/RTCPeerConnectionFactory+Private.h>
#import <peerconnection/RTCPeerConnectionFactoryBuilder+DefaultComponents.h>
#import "DeviceWrapper.h"
#import "../MediasoupClientError/MediasoupClientErrorHandler.h"


@interface DeviceWrapper() {
	mediasoupclient::Device *_device;
	mediasoupclient::PeerConnection::Options *_pcOptions;
}
@property(nonatomic, strong) RTCPeerConnectionFactoryBuilder *pcFactoryBuilder;
@property(nonatomic, strong) RTCPeerConnectionFactory *pcFactory;
@end


@implementation DeviceWrapper

- (instancetype)init {
	self = [super init];
	if (self != nil) {
		_device = new mediasoupclient::Device();

		self.pcFactoryBuilder = [RTCPeerConnectionFactoryBuilder defaultBuilder];
		self.pcFactory = [self.pcFactoryBuilder createPeerConnectionFactory];
		_pcOptions = new mediasoupclient::PeerConnection::Options();
		_pcOptions->factory = self.pcFactory.nativeFactory;
	}
	return self;
}

- (void)dealloc {
	delete _device;
	delete _pcOptions;

	// Properties are released explicitly to manage deallocation order.
	// PeerConnection must be released before PeerConnectionBuilder.
	self.pcFactoryBuilder = nil;
	self.pcFactory = nil;
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
	}, error);
}

- (NSString *_Nullable)rtpCapabilitiesWithError:(out NSError *__autoreleasing _Nullable *_Nullable)error {
	return mediasoupTryWithResult(^ NSString * {
		nlohmann::json const capabilities = self->_device->GetRtpCapabilities();
		return [NSString stringWithCString:capabilities.dump().c_str() encoding:NSUTF8StringEncoding];
	}, error);
}

- (BOOL)canProduce:(MediasoupClientMediaKind _Nonnull)mediaKind
	error:(out NSError *__autoreleasing _Nullable *_Nullable)error {

	return mediasoupTryWithBool(^ BOOL {
		return self->_device->CanProduce(std::string([mediaKind UTF8String]));
	}, error);
}

@end
