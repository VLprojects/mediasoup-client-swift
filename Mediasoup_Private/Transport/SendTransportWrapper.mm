#import <Transport.hpp>
#import "SendTransportWrapper.hpp"
#import "SendTransportListenerAdapter.hpp"
#import "../MediasoupClientError/MediasoupClientErrorHandler.h"


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
