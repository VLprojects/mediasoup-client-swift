#ifndef SendTransportWrapper_h
#define SendTransportWrapper_h

#import <Foundation/Foundation.h>
#import "SendTransportWrapperDelegate.h"

#ifdef __cplusplus
namespace mediasoupclient {
	class SendTransport;
}
class SendTransportListenerAdapter;
#endif


@interface SendTransportWrapper : NSObject

@property(nonatomic, nullable, weak) id<SendTransportWrapperDelegate> delegate;
@property(nonatomic, nonnull, readonly, getter = id) NSString *id;
@property(nonatomic, readonly, getter = closed) BOOL closed;
@property(nonatomic, nonnull, readonly, getter = connectionState) NSString *connectionState;
@property(nonatomic, nonnull, readonly, getter = appData) NSString *appData;
@property(nonatomic, nonnull, readonly, getter = stats) NSString *stats;

#ifdef __cplusplus
- (instancetype _Nullable)initWithTransport:(mediasoupclient::SendTransport *_Nonnull)transport
	listenerAdapter:(SendTransportListenerAdapter *_Nonnull)listenerAdapter;
#endif

- (void)close;

- (void)restartICE:(NSString *_Nonnull)iceParameters
	error:(out NSError *__autoreleasing _Nullable *_Nullable)error
	__attribute__((swift_error(nonnull_error)));

- (void)updateICEServers:(NSString *_Nonnull)iceServers
	error:(out NSError *__autoreleasing _Nullable *_Nullable)error
	__attribute__((swift_error(nonnull_error)));

@end

#endif /* SendTransportWrapper_h */
