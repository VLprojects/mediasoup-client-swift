#define MSC_CLASS "LoggerWrapper"

#import <Logger.hpp>
#import "LoggerWrapper.h"

#import <string>
#import <iostream>

using namespace mediasoupclient;

class DefaultLogHandler final : public mediasoupclient::Logger::LogHandlerInterface {
public:
    DefaultLogHandler() {
    }

    void OnLog(mediasoupclient::Logger::LogLevel level, char *payload, size_t len) override {
        std::string message(payload, len);
        switch (level) {
            case mediasoupclient::Logger::LogLevel::LOG_ERROR:
                std::cout << message << std::endl;
                break;
            case mediasoupclient::Logger::LogLevel::LOG_WARN:
                std::cout << message << std::endl;
                break;
            case mediasoupclient::Logger::LogLevel::LOG_DEBUG:
                std::cout << message << std::endl;
                break;
            case mediasoupclient::Logger::LogLevel::LOG_TRACE:
                std::cout << message << std::endl;
                break;
            default:
                break;
        }
    }

    mediasoupclient::Logger::LogLevel toEnum(uint8_t level) {
        switch (level) {
            case 1:
                return mediasoupclient::Logger::LogLevel::LOG_ERROR;
            case 2:
                return mediasoupclient::Logger::LogLevel::LOG_WARN;
            case 3:
                return mediasoupclient::Logger::LogLevel::LOG_DEBUG;
            case 4:
                return mediasoupclient::Logger::LogLevel::LOG_TRACE;
            default:
                return mediasoupclient::Logger::LogLevel::LOG_NONE;
        }
    }
};

DefaultLogHandler *globalLogHandler = new DefaultLogHandler();

@implementation LoggerWrapper
+ (void)setLogLevel:(uint8_t)level {
    mediasoupclient::Logger::LogLevel logLevel = globalLogHandler->toEnum(level);
    mediasoupclient::Logger::SetLogLevel(logLevel);
    mediasoupclient::Logger::SetHandler(globalLogHandler);
}

+ (void)errorWithLog:(NSString *)log {
    MSC_ERROR("%s", log.UTF8String);
}

+ (void)warnWithLog:(NSString *)log {
    MSC_WARN("%s", log.UTF8String);
}

+ (void)debugWithLog:(NSString *)log {
    MSC_DEBUG("%s", log.UTF8String);
}
@end
