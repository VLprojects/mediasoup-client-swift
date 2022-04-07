#import <Foundation/Foundation.h>
#import <Producer.hpp>
#import "ProducerWrapper.hpp"
#import "ProducerListenerAdapter.hpp"
#import "ProducerListenerAdapterDelegate.h"
#import "ProducerWrapperDelegate.h"


@interface ProducerWrapper () <ProducerListenerAdapterDelegate> {
	mediasoupclient::Producer *_producer;
	ProducerListenerAdapter *_listenerAdapter;
}
@end


@implementation ProducerWrapper

- (instancetype)initWithProducer:(mediasoupclient::Producer *_Nonnull)producer
	listenerAdapter:(ProducerListenerAdapter *_Nonnull)listenerAdapter {

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
	// TODO: delete _listenerAdapter
}

#pragma mark - ProducerListenerAdapterDelegate methods

- (void)onTransportClose:(ProducerListenerAdapter *_Nonnull)adapter {
	if (adapter != _listenerAdapter) {
		return;
	}

	[self.delegate onTransportClose:self];
}

@end
