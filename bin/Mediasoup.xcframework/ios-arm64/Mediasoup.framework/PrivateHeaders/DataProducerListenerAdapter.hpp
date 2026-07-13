#ifndef DataProducerListenerAdapter_h
#define DataProducerListenerAdapter_h

#import <Foundation/Foundation.h>
#import "DataProducer.hpp"


@protocol DataProducerListenerAdapterDelegate;


class DataProducerListenerAdapter final : public mediasoupclient::DataProducer::Listener {
public:
	__weak id<DataProducerListenerAdapterDelegate> delegate;

	DataProducerListenerAdapter();
	~DataProducerListenerAdapter() override = default;

	void OnOpen(mediasoupclient::DataProducer* dataProducer) override;
	void OnClose(mediasoupclient::DataProducer* dataProducer) override;
	void OnBufferedAmountChange(mediasoupclient::DataProducer* dataProducer, uint64_t sentDataSize) override;
	void OnTransportClose(mediasoupclient::DataProducer *producer) override;
};


#endif /* DataProducerListenerAdapter_h */
