#import "DataConsumerListenerAdapter.hpp"
#import "DataConsumerListenerAdapterDelegate.h"


DataConsumerListenerAdapter::DataConsumerListenerAdapter() {
}

DataConsumerListenerAdapter::~DataConsumerListenerAdapter() {
	this->delegate = nil;
}

void DataConsumerListenerAdapter::OnMessage(
	mediasoupclient::DataConsumer *dataConsumer,
	const webrtc::DataBuffer &buffer
) {
	auto data = [NSData dataWithBytes:buffer.data.data() length:buffer.size()];
	[this->delegate onMessage:data from:this];
}

void DataConsumerListenerAdapter::OnConnecting(mediasoupclient::DataConsumer *dataConsumer) {
	[this->delegate onConnecting:this];
}

void DataConsumerListenerAdapter::OnOpen(mediasoupclient::DataConsumer *dataConsumer) {
	[this->delegate onOpen:this];
}

void DataConsumerListenerAdapter::OnClosing(mediasoupclient::DataConsumer *dataConsumer) {
	[this->delegate onClosing:this];
}

void DataConsumerListenerAdapter::OnClose(mediasoupclient::DataConsumer *dataConsumer) {
	[this->delegate onClose:this];
}

void DataConsumerListenerAdapter::OnTransportClose(mediasoupclient::DataConsumer* dataconsumer) {
	// TODO: store __unsafe_unretained ref to Consumer and check if sender mathces?
	[this->delegate onTransportClose:this];
}
