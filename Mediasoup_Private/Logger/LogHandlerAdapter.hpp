#ifndef LogHandlerAdapter_h
#define LogHandlerAdapter_h

#import <Foundation/Foundation.h>
#import "Logger.hpp"
#import "MediasoupClientLogLevel.h"


@protocol LogHandlerWrapper;


class LogHandlerAdapter final : public mediasoupclient::Logger::LogHandlerInterface {
public:
	__weak id<LogHandlerWrapper> delegate;

	LogHandlerAdapter();
	virtual ~LogHandlerAdapter();
	virtual void OnLog(mediasoupclient::Logger::LogLevel level, char* payload, size_t len) override;

	static inline MediasoupClientLogLevel getWrappedLogLevel(mediasoupclient::Logger::LogLevel value);
};

#endif /* LogHandlerAdapter_h */
