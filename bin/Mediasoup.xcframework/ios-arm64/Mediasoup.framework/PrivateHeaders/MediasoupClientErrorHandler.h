#ifndef MediasoupErrorHandler_h
#define MediasoupErrorHandler_h

#import <Foundation/Foundation.h>
#import "MediasoupClientError.h"
#import "MediaSoupClientErrors.hpp"


NSError *_Nonnull const mediasoupError(
	MediasoupClientErrorCode const code,
	std::exception const *_Nonnull const e
);

template<typename ReturnType>
ReturnType mediasoupTryWithResult(
	ReturnType (^_Nonnull throwingBlock)(void),
	void (^_Nullable catchBlock)(void),
	NSError *__autoreleasing _Nullable *_Nullable error) {

	try {
		return throwingBlock();
	} catch (const MediaSoupClientUnsupportedError &e) {
		*error = mediasoupError(MediasoupClientErrorCodeUnsupported, &e);
	} catch (const MediaSoupClientInvalidStateError &e) {
		*error = mediasoupError(MediasoupClientErrorCodeInvalidState, &e);
	} catch (const MediaSoupClientTypeError &e) {
		*error = mediasoupError(MediasoupClientErrorCodeInvalidParameters, &e);
	} catch (const MediaSoupClientError &e) {
		*error = mediasoupError(MediasoupClientErrorCodeUnknown, &e);
	} catch (const std::exception &e) {
		*error = mediasoupError(MediasoupClientErrorCodeUnknown, &e);
	} catch (id e) {
		*error = [NSError errorWithDomain:MediasoupClientErrorDomain code:MediasoupClientErrorCodeUnknown userInfo:nil];
	}

	if (catchBlock != nil) {
		catchBlock();
	}
	return nil;
}

void mediasoupTry(
	void (^_Nonnull throwingBlock)(void),
	NSError *__autoreleasing _Nullable *_Nullable error);

BOOL mediasoupTryWithBool(
	BOOL (^_Nonnull throwingBlock)(void),
	NSError *__autoreleasing _Nullable *_Nullable error);

#endif /* MediasoupErrorHandler_h */
