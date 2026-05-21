#import "LoggerWrapper.hpp"
#import <mediasoupclient.hpp>
#import "Logger.hpp"
#import "LogHandlerAdapter.hpp"
#import "LogHandlerWrapper.h"


static LogHandlerAdapter *_adapter;


@interface LoggerWrapper ()
@end


@implementation LoggerWrapper

+ (MediasoupClientLogLevel)logLevel {
	auto logLevel = mediasoupclient::Logger::logLevel;
	return LogHandlerAdapter::getWrappedLogLevel(logLevel);
}

+ (void)setLogLevel:(MediasoupClientLogLevel)logLevel {
	auto nativeValue = getNativeLogLevel(logLevel);
	mediasoupclient::Logger::SetLogLevel(nativeValue);
}

+ (void)setHandler:(id<LogHandlerWrapper>)adapterDelegate {
	if (_adapter == nil) {
		_adapter = new LogHandlerAdapter();
	}
	_adapter->delegate = adapterDelegate;
	mediasoupclient::Logger::SetHandler(_adapter);
}

+ (void)setDefaultHandler {
	if (_adapter != nil) {
		delete _adapter;
		_adapter = nil;
	}
	mediasoupclient::Logger::SetDefaultHandler();
}

static inline mediasoupclient::Logger::LogLevel getNativeLogLevel(MediasoupClientLogLevel value) {
	switch (value) {
		case MediasoupClientLogLevelNone:
			return mediasoupclient::Logger::LogLevel::LOG_NONE;

		case MediasoupClientLogLevelError:
			return mediasoupclient::Logger::LogLevel::LOG_ERROR;

		case MediasoupClientLogLevelWarning:
			return mediasoupclient::Logger::LogLevel::LOG_WARN;

		case MediasoupClientLogLevelDebug:
			return mediasoupclient::Logger::LogLevel::LOG_DEBUG;

		case MediasoupClientLogLevelTrace:
			return mediasoupclient::Logger::LogLevel::LOG_TRACE;
	}
}

@end
