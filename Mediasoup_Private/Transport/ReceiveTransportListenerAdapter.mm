#import <MediaSoupClientErrors.hpp>
#import "ReceiveTransportListenerAdapter.hpp"


ReceiveTransportListenerAdapter::ReceiveTransportListenerAdapter() {
}

ReceiveTransportListenerAdapter::~ReceiveTransportListenerAdapter() {
	this->delegate = nil;
}

std::future<void> ReceiveTransportListenerAdapter::OnConnect(
	mediasoupclient::Transport* nativeTransport,
	const nlohmann::json& dtlsParameters) {

	auto dtlsParametersString = [NSString stringWithUTF8String:dtlsParameters.dump().c_str()];

	[this->delegate onConnect:this dtlsParameters:dtlsParametersString];

	std::promise<void> promise;
	promise.set_value();
	return promise.get_future();
};

void ReceiveTransportListenerAdapter::OnConnectionStateChange(
	mediasoupclient::Transport *nativeTransport,
	const std::string &connectionState) {

	auto connectionStateString = [NSString stringWithUTF8String:connectionState.c_str()];

	[this->delegate onConnectionStateChange:this connectionState:connectionStateString];
};
