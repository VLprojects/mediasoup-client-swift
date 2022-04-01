#ifndef DeviceWrapper_h
#define DeviceWrapper_h

#import <Foundation/Foundation.h>


@interface DeviceWrapper : NSObject

- (void)loadWithRouterRTPCapabilities:(NSString *_Nonnull)routerRTPCapabilities
	error:(out NSError *__autoreleasing _Nullable *_Nullable)error
	__attribute__((swift_error(nonnull_error)))
	NS_SWIFT_NAME (load(with:));

- (NSString *_Nullable)getSCTPCapabilitiesWithError
	:(out NSError *__autoreleasing _Nullable *_Nullable)error;

@end

#endif /* DeviceWrapper_h */
