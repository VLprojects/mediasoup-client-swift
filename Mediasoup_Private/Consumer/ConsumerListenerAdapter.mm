#import "ConsumerListenerAdapter.hpp"
#import "ConsumerListenerAdapterDelegate.h"


ConsumerListenerAdapter::ConsumerListenerAdapter() {
}

ConsumerListenerAdapter::~ConsumerListenerAdapter() {
	this->delegate = nil;
}

void ConsumerListenerAdapter::OnTransportClose(mediasoupclient::Consumer* consumer) {
	// TODO: store __unsafe_unretained ref to Consumer and check if sender mathces?
	[this->delegate onTransportClose:this];
}
