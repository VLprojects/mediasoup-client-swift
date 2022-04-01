#ifndef DeviceWrapper_h
#define DeviceWrapper_h

#import <Foundation/Foundation.h>
#import "MediasoupClientMediaKind.h"


@interface DeviceWrapper : NSObject

- (BOOL)isLoaded;

- (void)loadWithRouterRTPCapabilities:(NSString *_Nonnull)routerRTPCapabilities
	error:(out NSError *__autoreleasing _Nullable *_Nullable)error
	__attribute__((swift_error(nonnull_error)))
	NS_SWIFT_NAME (load(with:));

- (NSString *_Nullable)sctpCapabilitiesWithError
	:(out NSError *__autoreleasing _Nullable *_Nullable)error;

- (NSString *_Nullable)rtpCapabilitiesWithError
	:(out NSError *__autoreleasing _Nullable *_Nullable)error;

- (BOOL)canProduce:(MediasoupClientMediaKind _Nonnull)mediaKind
	error:(out NSError *__autoreleasing _Nullable *_Nullable)error
	__attribute__((swift_error(nonnull_error)));

@end

#endif /* DeviceWrapper_h */
