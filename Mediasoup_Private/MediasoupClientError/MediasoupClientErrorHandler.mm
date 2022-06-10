#import "MediasoupClientErrorHandler.h"


NSError *_Nonnull const mediasoupError(
	MediasoupClientErrorCode const code,
	std::exception const *_Nonnull const e) {

	auto errorDescription = [NSString stringWithCString:e->what() encoding:NSUTF8StringEncoding];
	auto userInfo = @{
		NSLocalizedDescriptionKey: errorDescription
	};
	return [NSError errorWithDomain:MediasoupClientErrorDomain code:code userInfo:userInfo];
}

void mediasoupTry(
	void (^_Nonnull throwingBlock)(void),
	NSError *__autoreleasing _Nullable *_Nullable error) {

	try {
		throwingBlock();
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
}

BOOL mediasoupTryWithBool(
	BOOL (^_Nonnull throwingBlock)(void),
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

	return NO;
}
