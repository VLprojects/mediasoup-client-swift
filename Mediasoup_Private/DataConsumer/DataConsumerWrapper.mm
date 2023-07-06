#import <Foundation/Foundation.h>
#import <DataConsumer.hpp>
#import <WebRTC/RTCMediaStreamTrack.h>
#import "DataConsumerWrapper.hpp"
#import "DataConsumerListenerAdapter.hpp"
#import "DataConsumerListenerAdapterDelegate.h"
#import "DataConsumerWrapperDelegate.h"
#import "../MediasoupClientError/MediasoupClientErrorHandler.h"


@interface DataConsumerWrapper () <DataConsumerListenerAdapterDelegate> {
	mediasoupclient::DataConsumer *_consumer;
	DataConsumerListenerAdapter *_listenerAdapter;
}
@end


@implementation DataConsumerWrapper

- (instancetype)initWithDataConsumer:(mediasoupclient::DataConsumer *_Nonnull)consumer
	listenerAdapter:(DataConsumerListenerAdapter *_Nonnull)listenerAdapter {

	self = [super init];

	if (self != nil) {
		_consumer = consumer;
		_listenerAdapter = listenerAdapter;
		_listenerAdapter->delegate = self;
	}

	return self;
}

- (void)dealloc {
	delete _consumer;
	delete _listenerAdapter;
}

#pragma mark - Public methods

- (NSString *_Nonnull)id {
	return [NSString stringWithUTF8String:_consumer->GetId().c_str()];
}

- (NSString *_Nonnull)producerId {
	return [NSString stringWithUTF8String:_consumer->GetDataProducerId().c_str()];
}

- (NSString *_Nonnull)localId {
	return [NSString stringWithUTF8String:_consumer->GetLocalId().c_str()];
}

- (BOOL)closed {
	return _consumer->IsClosed() == true;
}

- (NSString *_Nonnull)label {
	return [NSString stringWithUTF8String:_consumer->GetLabel().c_str()];
}

- (NSString *_Nonnull)dataProtocol {
	return [NSString stringWithUTF8String:_consumer->GetProtocol().c_str()];
}

- (NSString *_Nonnull)sctpStreamParameters {
	return [NSString stringWithUTF8String:_consumer->GetSctpStreamParameters().dump().c_str()];
}

- (NSString *_Nonnull)appData {
	return [NSString stringWithUTF8String:_consumer->GetAppData().dump().c_str()];
}

- (void)close {
	_consumer->Close();
}

#pragma mark - ProducerListenerAdapterDelegate methods

- (void)onConnecting:(DataConsumerListenerAdapter *_Nonnull)adapter {
	if (adapter != _listenerAdapter) {
		return;
	}

	[self.delegate onConnecting:self];
}

- (void)onOpen:(DataConsumerListenerAdapter *_Nonnull)adapter {
	if (adapter != _listenerAdapter) {
		return;
	}

	[self.delegate onOpen:self];
}

- (void)onClosing:(DataConsumerListenerAdapter *_Nonnull)adapter {
	if (adapter != _listenerAdapter) {
		return;
	}

	[self.delegate onClosing:self];
}

- (void)onClose:(DataConsumerListenerAdapter *_Nonnull)adapter {
	if (adapter != _listenerAdapter) {
		return;
	}

	[self.delegate onClose:self];
}

- (void)onTransportClose:(DataConsumerListenerAdapter *_Nonnull)adapter {
	if (adapter != _listenerAdapter) {
		return;
	}

	[self.delegate onTransportClose:self];
}

- (void)onMessage:(NSData *)messageData from:(DataConsumerListenerAdapter * _Nonnull)adapter {
	if (adapter != _listenerAdapter) {
		return;
	}

	[self.delegate onMessage:messageData consumer:self];
}

@end
