#ifndef ReceiveTransportListenerAdapter_h
#define ReceiveTransportListenerAdapter_h

#import <Foundation/Foundation.h>
#import <Transport.hpp>
#import "ReceiveTransportListenerAdapterDelegate.h"


class ReceiveTransportListenerAdapter final : public mediasoupclient::RecvTransport::Listener {
public:
	__weak id<ReceiveTransportListenerAdapterDelegate> delegate;

	ReceiveTransportListenerAdapter();
	virtual ~ReceiveTransportListenerAdapter();

	std::future<void> OnConnect(
		mediasoupclient::Transport *nativeTransport,
		const nlohmann::json &dtlsParameters) override;

	void OnConnectionStateChange(
		mediasoupclient::Transport *nativeTransport,
		const std::string &connectionState) override;
};

#endif /* ReceiveTransportListenerAdapter_h */
