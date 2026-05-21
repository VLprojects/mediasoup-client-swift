#ifndef MediasoupClientLogLevel_h
#define MediasoupClientLogLevel_h

#import <Foundation/Foundation.h>


typedef NS_ENUM(uint8_t, MediasoupClientLogLevel) {
	MediasoupClientLogLevelNone,
	MediasoupClientLogLevelError,
	MediasoupClientLogLevelWarning,
	MediasoupClientLogLevelDebug,
	MediasoupClientLogLevelTrace
};

#endif /* MediasoupClientLogLevel_h */
