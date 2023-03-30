#import <MediaSoupClientErrors.hpp>
#import "SendTransportListenerAdapter.hpp"


SendTransportListenerAdapter::SendTransportListenerAdapter() {
}

SendTransportListenerAdapter::~SendTransportListenerAdapter() {
	this->delegate = nil;
}

std::future<void> SendTransportListenerAdapter::OnConnect(
	mediasoupclient::Transport* nativeTransport,
	const nlohmann::json& dtlsParameters) {

	auto dtlsParametersString = [NSString stringWithUTF8String:dtlsParameters.dump().c_str()];

	[this->delegate onConnect:this dtlsParameters:dtlsParametersString];

	std::promise<void> promise;
	promise.set_value();
	return promise.get_future();
};

void SendTransportListenerAdapter::OnConnectionStateChange(
	mediasoupclient::Transport *nativeTransport,
	const std::string &connectionState) {

	auto connectionStateString = [NSString stringWithUTF8String:connectionState.c_str()];

	[this->delegate onConnectionStateChange:this connectionState:connectionStateString];
};

std::future<std::string> SendTransportListenerAdapter::OnProduce(
	mediasoupclient::SendTransport *nativeTransport,
	const std::string &kind,
	nlohmann::json rtpParameters,
	const nlohmann::json &appData) {

	auto kindString = [NSString stringWithUTF8String:kind.c_str()];
	auto rtpParametersString = [NSString stringWithUTF8String:rtpParameters.dump().c_str()];
	auto appDataString = [NSString stringWithUTF8String:appData.dump().c_str()];

	__block std::promise<std::string> promise;

	[this->delegate onProduce:this kind:kindString rtpParameters:rtpParametersString
		appData: appDataString callback: ^(NSString *id) {
			try {
				if (id == nil) {
					auto ep = make_exception_ptr(MediaSoupClientError("ProducerIdIsNil"));
					promise.set_exception(ep);
				} else {
					promise.set_value(std::string([id UTF8String]));
				}
			} catch(...) {
			}
		}];

	return promise.get_future();
};

std::future<std::string> SendTransportListenerAdapter::OnProduceData(
	mediasoupclient::SendTransport *nativeTransport,
	const nlohmann::json &sctpStreamParameters,
	const std::string &label,
	const std::string &protocol,
	const nlohmann::json &appData) {

	auto sctpParametersString = [NSString stringWithUTF8String:sctpStreamParameters.dump().c_str()];
	auto labelString = [NSString stringWithUTF8String:label.c_str()];
	auto protocolString = [NSString stringWithUTF8String:protocol.c_str()];
	auto appDataString = [NSString stringWithUTF8String:appData.dump().c_str()];

	__block std::promise<std::string> promise;

	[this->delegate onProduceData:this sctpParameters:sctpParametersString label:labelString
		protocol:protocolString appData:appDataString callback: ^(NSString *id) {
			try {
				if (id == nil) {
					auto ep = make_exception_ptr(MediaSoupClientError("ProducerIdIsNil"));
					promise.set_exception(ep);
				} else {
					promise.set_value(std::string([id UTF8String]));
				}
			} catch(...) {
			}
		}];

	return promise.get_future();
};
