#ifndef ProducerListenerAdapter_h
#define ProducerListenerAdapter_h

#import <Foundation/Foundation.h>
#import "Producer.hpp"


@protocol ProducerListenerAdapterDelegate;


class ProducerListenerAdapter final : public mediasoupclient::Producer::Listener {
public:
	__weak id<ProducerListenerAdapterDelegate> delegate;

	ProducerListenerAdapter();
	virtual ~ProducerListenerAdapter();

	void OnTransportClose(mediasoupclient::Producer *producer) override;
};


#endif /* ProducerListenerAdapter_h */
