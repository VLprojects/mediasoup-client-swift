#import <Foundation/Foundation.h>
#import <api/data_channel_interface.h>
#import <DataProducer.hpp>
#import "DataProducerWrapper.hpp"
#import "DataProducerListenerAdapter.hpp"
#import "DataProducerListenerAdapterDelegate.h"
#import "DataProducerWrapperDelegate.h"
#import "WrappedDataState.hpp"
#import "../MediasoupClientError/MediasoupClientErrorHandler.h"


@interface DataProducerWrapper () <DataProducerListenerAdapterDelegate> {
	mediasoupclient::DataProducer *_producer;
	DataProducerListenerAdapter *_listenerAdapter;
}
@end


@implementation DataProducerWrapper

- (instancetype)initWithDataProducer:(mediasoupclient::DataProducer *_Nonnull)producer
	listenerAdapter:(DataProducerListenerAdapter *_Nonnull)listenerAdapter {

	self = [super init];

	if (self != nil) {
		_producer = producer;
		_listenerAdapter = listenerAdapter;
		_listenerAdapter->delegate = self;
	}

	return self;
}

- (void)dealloc {
	delete _producer;
	delete _listenerAdapter;
}

#pragma mark - Public methods

- (NSString *_Nonnull)id {
	return [NSString stringWithUTF8String:_producer->GetId().c_str()];
}

- (NSString *_Nonnull)localId {
	return [NSString stringWithUTF8String:_producer->GetLocalId().c_str()];
}

- (NSString *_Nonnull)sctpStreamParameters {
	return [NSString stringWithUTF8String:_producer->GetSctpStreamParameters().dump().c_str()];
}

- (WrappedDataState)readyState {
	auto nativeReadyState = _producer->GetReadyState();
	switch (nativeReadyState) {
		case webrtc::DataChannelInterface::kConnecting: return WrappedDataStateConnecting;
		case webrtc::DataChannelInterface::kOpen: return WrappedDataStateOpen;
		case webrtc::DataChannelInterface::kClosing: return WrappedDataStateClosing;
		case webrtc::DataChannelInterface::kClosed: return WrappedDataStateClosed;
	}
}

- (NSString *_Nonnull)label {
	return [NSString stringWithUTF8String:_producer->GetLabel().c_str()];
}

- (NSString *_Nonnull)protocol {
	return [NSString stringWithUTF8String:_producer->GetProtocol().c_str()];
}

- (UInt64)bufferedAmount {
	return _producer->GetBufferedAmount();
}

- (NSString *_Nonnull)appData {
	return [NSString stringWithUTF8String:_producer->GetAppData().dump().c_str()];
}

- (BOOL)closed {
	return _producer->IsClosed() == true;
}

- (void)send:(NSData *_Nonnull)buffer {
//	webrtc::Copy CopyOnWriteBuffer(const T* data, size_t size)
//	webrtc::DataBuffer webrtcBuffer();
//	_producer->Send(const  &buffer)
}

- (void)close {
	_producer->Close();
}

#pragma mark - DataProducerListenerAdapterDelegate methods

- (void)onTransportClose:(DataProducerListenerAdapter *_Nonnull)adapter {
	if (adapter != _listenerAdapter) {
		return;
	}

	[self.delegate onTransportClose:self];
}

- (void)onBufferedAmountChange:(DataProducerListenerAdapter * _Nonnull)adapter dataSize:(uint64_t)sentDataSize {
	if (adapter != _listenerAdapter) {
		return;
	}

	[self.delegate onBufferedAmountChange:self dataSize:sentDataSize];
}

- (void)onClose:(DataProducerListenerAdapter * _Nonnull)adapter {
	if (adapter != _listenerAdapter) {
		return;
	}

	[self.delegate onClose:self];
}


- (void)onOpen:(DataProducerListenerAdapter * _Nonnull)adapter { 
	if (adapter != _listenerAdapter) {
		return;
	}

	[self.delegate onOpen:self];
}

@end
