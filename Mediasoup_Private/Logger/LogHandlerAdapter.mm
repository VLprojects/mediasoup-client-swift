#import "LogHandlerAdapter.hpp"
#import "LogHandlerWrapper.h"
#import "Logger.hpp"


LogHandlerAdapter::LogHandlerAdapter() {
}

LogHandlerAdapter::~LogHandlerAdapter() {
	this->delegate = nil;
}

void LogHandlerAdapter::OnLog(mediasoupclient::Logger::LogLevel level, char* payload, size_t len) {
	NSString *payloadString = [[NSString alloc] initWithBytes:payload length:len encoding:NSUTF8StringEncoding];
	[this->delegate onLog:getWrappedLogLevel(level) payload:payloadString];
}

inline MediasoupClientLogLevel LogHandlerAdapter::getWrappedLogLevel(mediasoupclient::Logger::LogLevel value) {
	switch (value) {
		case mediasoupclient::Logger::LogLevel::LOG_NONE:
			return MediasoupClientLogLevelNone;

		case mediasoupclient::Logger::LogLevel::LOG_ERROR:
			return MediasoupClientLogLevelError;

		case mediasoupclient::Logger::LogLevel::LOG_WARN:
			return MediasoupClientLogLevelWarning;

		case mediasoupclient::Logger::LogLevel::LOG_DEBUG:
			return MediasoupClientLogLevelDebug;

		case mediasoupclient::Logger::LogLevel::LOG_TRACE:
			return MediasoupClientLogLevelTrace;
	}
}
