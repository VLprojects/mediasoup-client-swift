#ifndef ReceiveTransportWrapper_h
#define ReceiveTransportWrapper_h

#import <Foundation/Foundation.h>
#import "MediasoupClientMediaKind.h"

#ifdef __cplusplus
namespace mediasoupclient {
	class RecvTransport;
}
class ReceiveTransportListenerAdapter;
#endif

@class ConsumerWrapper;
@class RTCPeerConnectionFactory;
@protocol ReceiveTransportWrapperDelegate;
typedef NS_ENUM(NSInteger, RTCIceTransportPolicy);


@interface ReceiveTransportWrapper : NSObject

@property(nonatomic, nullable, weak) id<ReceiveTransportWrapperDelegate> delegate;
@property(nonatomic, nonnull, readonly, getter = id) NSString *id;
@property(nonatomic, readonly, getter = closed) BOOL closed;
@property(nonatomic, nonnull, readonly, getter = connectionState) NSString *connectionState;
@property(nonatomic, nonnull, readonly, getter = appData) NSString *appData;
@property(nonatomic, nonnull, readonly, getter = stats) NSString *stats;

#ifdef __cplusplus
- (instancetype _Nullable)initWithTransport:(mediasoupclient::RecvTransport *_Nonnull)transport
	pcFactory:(RTCPeerConnectionFactory *_Nonnull)pcFactory
	listenerAdapter:(ReceiveTransportListenerAdapter *_Nonnull)listenerAdapter;
#endif

- (void)close;

- (void)restartICE:(NSString *_Nonnull)iceParameters
	error:(out NSError *__autoreleasing _Nullable *_Nullable)error
	__attribute__((swift_error(nonnull_error)));

- (void)updateICEServers:(NSString *_Nonnull)iceServers
	error:(out NSError *__autoreleasing _Nullable *_Nullable)error
	__attribute__((swift_error(nonnull_error)));

- (void)updateICETransportPolicy:(RTCIceTransportPolicy)iceTransportPolicy
	error:(out NSError *__autoreleasing _Nullable *_Nullable)error
	__attribute__((swift_error(nonnull_error)));

- (ConsumerWrapper *_Nullable)createConsumerWithId:(NSString *_Nonnull)consumerId
	producerId:(NSString *_Nonnull)producerId
	kind:(MediasoupClientMediaKind _Nonnull)kind
	rtpParameters:(NSString *_Nonnull)rtpParameters
	appData:(NSString *_Nullable)appData
	error:(out NSError *__autoreleasing _Nullable *_Nullable)error;

@end

#endif /* ReceiveTransportWrapper_h */
