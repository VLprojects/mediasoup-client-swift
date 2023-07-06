#ifndef DataConsumerListenerAdapter_h
#define DataConsumerListenerAdapter_h

#import <Foundation/Foundation.h>
#import "DataConsumer.hpp"


@protocol DataConsumerListenerAdapterDelegate;


class DataConsumerListenerAdapter final : public mediasoupclient::DataConsumer::Listener {
public:
	__weak id<DataConsumerListenerAdapterDelegate> delegate;

	DataConsumerListenerAdapter();
	virtual ~DataConsumerListenerAdapter();

	void OnConnecting(mediasoupclient::DataConsumer *dataConsumer) override;
	void OnOpen(mediasoupclient::DataConsumer *dataConsumer) override;
	void OnClosing(mediasoupclient::DataConsumer *dataConsumer) override;
	void OnClose(mediasoupclient::DataConsumer *dataConsumer) override;
	void OnTransportClose(mediasoupclient::DataConsumer *dataConsumer) override;

	void OnMessage(
		mediasoupclient::DataConsumer *dataConsumer,
		const webrtc::DataBuffer &buffer
	) override;

};

#endif /* DataConsumerListenerAdapter_h */
