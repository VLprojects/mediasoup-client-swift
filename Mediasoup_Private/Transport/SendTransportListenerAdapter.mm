#import <MediaSoupClientErrors.hpp>
#import "SendTransportListenerAdapter.hpp"


SendTransportListenerAdapter::SendTransportListenerAdapter() {
}

SendTransportListenerAdapter::~SendTransportListenerAdapter() {
}

std::future<void> SendTransportListenerAdapter::OnConnect(
	mediasoupclient::Transport* nativeTransport,
	const nlohmann::json& dtlsParameters) {

	auto transportId = [NSString stringWithUTF8String:nativeTransport->GetId().c_str()];
	auto dtlsParametersString = [NSString stringWithUTF8String:dtlsParameters.dump().c_str()];

	[this->delegate onConnect:transportId dtlsParameters:dtlsParametersString];

	std::promise<void> promise;
	promise.set_value();
	return promise.get_future();
};

void SendTransportListenerAdapter::OnConnectionStateChange(
	mediasoupclient::Transport *nativeTransport,
	const std::string &connectionState) {

	auto transportId = [NSString stringWithUTF8String:nativeTransport->GetId().c_str()];
	auto connectionStateString = [NSString stringWithUTF8String:connectionState.c_str()];

	[this->delegate onConnectionStateChange:transportId connectionState:connectionStateString];
};

std::future<std::string> SendTransportListenerAdapter::OnProduce(
	mediasoupclient::SendTransport *nativeTransport,
	const std::string &kind,
	nlohmann::json rtpParameters,
	const nlohmann::json &appData) {

	auto transportId = [NSString stringWithUTF8String:nativeTransport->GetId().c_str()];
	auto kindString = [NSString stringWithUTF8String:kind.c_str()];
	auto rtpParametersString = [NSString stringWithUTF8String:rtpParameters.dump().c_str()];
	auto appDataString = [NSString stringWithUTF8String:appData.dump().c_str()];

	__block std::promise<std::string> promise;

	[this->delegate onProduce:transportId kind: kindString rtpParameters:rtpParametersString
		appData: appDataString callback: ^(NSString *id) {
			try {
				if (id == nil) {
					auto ep = make_exception_ptr(MediaSoupClientError("TransportIdIsNil"));
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

	__block std::promise<std::string> promise;
	promise.set_value(std::string("not implemented"));
	return promise.get_future();
};
