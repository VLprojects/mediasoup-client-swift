#import "DeviceWrapper.h"
#import "Device.hpp"
#import "../MediasoupClientError/MediasoupClientErrorHandler.h"


@interface DeviceWrapper() {
	mediasoupclient::Device *_device;
}
@end


@implementation DeviceWrapper

- (instancetype)init {
	self = [super init];
	if (self != nil) {
		_device = new mediasoupclient::Device();
	}
	return self;
}

- (void)dealloc {
	if (_device) {
		delete _device;
		_device = NULL;
	}
}

- (void)loadWithRouterRTPCapabilities:(NSString *)routerRTPCapabilities
	error:(out NSError *__autoreleasing _Nullable *_Nullable)error {

	mediasoupTry(^{
		auto routerRTPCapabilitiesJSON = nlohmann::json::parse(std::string([routerRTPCapabilities UTF8String]));
		mediasoupclient::PeerConnection::Options *pcOptions = nil;
////		const auto pcOptions = reinterpret_cast<mediasoupclient::PeerConnection::Options *>([nativePCOptions pointerValue]);
		self->_device->Load(routerRTPCapabilitiesJSON, pcOptions);
	}, error);
}

- (NSString *_Nullable)getSCTPCapabilitiesWithError:(out NSError *__autoreleasing _Nullable *_Nullable)error {
	return mediasoupTryWithResult(^{
		nlohmann::json const capabilities = self->_device->GetSctpCapabilities();
		return [NSString stringWithCString:capabilities.dump().c_str() encoding:NSUTF8StringEncoding];
	}, error);
}

@end
