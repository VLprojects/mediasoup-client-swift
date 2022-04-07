#import "ProducerListenerAdapter.hpp"
#import "ProducerListenerAdapterDelegate.h"


ProducerListenerAdapter::ProducerListenerAdapter() {
}

ProducerListenerAdapter::~ProducerListenerAdapter() {
	this->delegate = nil;
}

void ProducerListenerAdapter::OnTransportClose(mediasoupclient::Producer* producer) {
	// TODO: store __unsafe_unretained ref to Producer and check if sender mathces?
	[this->delegate onTransportClose:this];
}
