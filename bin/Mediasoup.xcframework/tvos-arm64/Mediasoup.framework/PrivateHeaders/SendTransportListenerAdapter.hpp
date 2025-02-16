#ifndef SendTransportListenerAdapter_h
#define SendTransportListenerAdapter_h

#import <Foundation/Foundation.h>
#import <Transport.hpp>
#import "SendTransportListenerAdapterDelegate.h"


class SendTransportListenerAdapter final : public mediasoupclient::SendTransport::Listener {
public:
	__weak id<SendTransportListenerAdapterDelegate> delegate;

	SendTransportListenerAdapter();
	virtual ~SendTransportListenerAdapter();

	std::future<void> OnConnect(
		mediasoupclient::Transport *nativeTransport,
		const nlohmann::json &dtlsParameters) override;

	void OnConnectionStateChange(
		mediasoupclient::Transport *nativeTransport,
		const std::string &connectionState) override;

	std::future<std::string> OnProduce(
		mediasoupclient::SendTransport *nativeTransport,
		const std::string &kind,
		nlohmann::json rtpParameters,
		const nlohmann::json &appData) override;

	std::future<std::string> OnProduceData(
		mediasoupclient::SendTransport *nativeTransport,
		const nlohmann::json &sctpStreamParameters,
		const std::string &label,
		const std::string &protocol,
		const nlohmann::json &appData) override;

};

#endif /* SendTransportListenerAdapter_h */
