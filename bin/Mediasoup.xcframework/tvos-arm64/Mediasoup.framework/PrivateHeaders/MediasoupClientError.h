#ifndef MediasoupClientError_h
#define MediasoupClientError_h

#import <Foundation/Foundation.h>


extern NSErrorDomain _Nonnull const MediasoupClientErrorDomain;

typedef NS_ERROR_ENUM(MediasoupClientErrorDomain, MediasoupClientErrorCode) {
	MediasoupClientErrorCodeUnsupported,
	MediasoupClientErrorCodeInvalidState,
	MediasoupClientErrorCodeInvalidParameters,
	MediasoupClientErrorCodeUnknown,
};

#endif /* MediasoupClientError_h */
