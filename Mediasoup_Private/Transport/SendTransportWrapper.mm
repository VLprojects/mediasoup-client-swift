#import <Transport.hpp>
#import "SendTransportWrapper.hpp"
#import "SendTransportListenerAdapter.hpp"


@interface SendTransportWrapper () <SendTransportListenerAdapterDelegate> {
	mediasoupclient::SendTransport *_transport;
	SendTransportListenerAdapter *_listenerAdapter;
}
@end


@implementation SendTransportWrapper

- (instancetype)initWithTransport:(mediasoupclient::SendTransport *)transport
	listenerAdapter:(SendTransportListenerAdapter *)listenerAdapter {

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
	// TODO: delete _listenerAdapter
}

- (void)onConnect:(NSString *)transportId dtlsParameters:(NSString *)dtlsParameters {
	[self.delegate onConnect:transportId dtlsParameters:dtlsParameters];
}

- (void)onConnectionStateChange:(NSString *)transportId connectionState:(NSString *)connectionState {
	[self.delegate onConnectionStateChange:transportId connectionState:connectionState];
}

- (void)onProduce:(NSString *)transportId
	kind:(NSString *)kind
	rtpParameters:(NSString *)rtpParameters
	appData:(NSString *)appData
	callback:(void(^)(NSString *))callback {

	[self.delegate onProduce:transportId kind:kind rtpParameters:rtpParameters appData:appData callback:callback];
}

@end
