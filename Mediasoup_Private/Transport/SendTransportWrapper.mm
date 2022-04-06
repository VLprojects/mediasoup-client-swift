#import <Transport.hpp>
#import "SendTransportWrapper.hpp"
#import "SendTransportListenerAdapter.hpp"


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
	// TODO: delete _listenerAdapter
}

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
