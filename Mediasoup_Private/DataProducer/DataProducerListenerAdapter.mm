#import "DataProducerListenerAdapter.hpp"
#import "DataProducerListenerAdapterDelegate.h"


DataProducerListenerAdapter::DataProducerListenerAdapter() {
}

void DataProducerListenerAdapter::OnOpen(mediasoupclient::DataProducer* dataProducer) {
	[this->delegate onOpen:this];
}

void DataProducerListenerAdapter::OnClose(mediasoupclient::DataProducer* dataProducer) {
	[this->delegate onClose:this];
}

void DataProducerListenerAdapter::OnBufferedAmountChange(mediasoupclient::DataProducer* dataProducer, uint64_t sentDataSize) {
	[this->delegate onBufferedAmountChange:this dataSize:sentDataSize];
}

void DataProducerListenerAdapter::OnTransportClose(mediasoupclient::DataProducer* producer) {
	[this->delegate onTransportClose:this];
}
