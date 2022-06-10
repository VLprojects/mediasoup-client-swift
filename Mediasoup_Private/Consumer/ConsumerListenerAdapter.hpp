#ifndef ConsumerListenerAdapter_h
#define ConsumerListenerAdapter_h

#import <Foundation/Foundation.h>
#import "Consumer.hpp"


@protocol ConsumerListenerAdapterDelegate;


class ConsumerListenerAdapter final : public mediasoupclient::Consumer::Listener {
public:
	__weak id<ConsumerListenerAdapterDelegate> delegate;

	ConsumerListenerAdapter();
	virtual ~ConsumerListenerAdapter();

	void OnTransportClose(mediasoupclient::Consumer *consumer) override;
};

#endif /* ConsumerListenerAdapter_h */
