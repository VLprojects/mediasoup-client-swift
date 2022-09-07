#ifndef ConsumerWrapper_h
#define ConsumerWrapper_h

#import <Foundation/Foundation.h>

#ifdef __cplusplus
namespace mediasoupclient {
	class Consumer;
}
class ConsumerListenerAdapter;
#endif

@class RTCMediaStreamTrack;
@protocol ConsumerWrapperDelegate;


@interface ConsumerWrapper : NSObject

@property(nonatomic, nullable, weak) id<ConsumerWrapperDelegate> delegate;
@property(nonatomic, nonnull, readonly) RTCMediaStreamTrack *track;
@property(nonatomic, nonnull, readonly, getter = id) NSString *id;
@property(nonatomic, nonnull, readonly, getter = producerId) NSString *producerId;
@property(nonatomic, nonnull, readonly, getter = localId) NSString *localId;
@property(nonatomic, readonly, getter = closed) BOOL closed;
@property(nonatomic, readonly, getter = paused) BOOL paused;
@property(nonatomic, nonnull, readonly, getter = kind) NSString *kind;
@property(nonatomic, nonnull, readonly, getter = appData) NSString *appData;
@property(nonatomic, nonnull, readonly, getter = rtpParameters) NSString *rtpParameters;
@property(nonatomic, nonnull, readonly, getter = stats) NSString *stats;

#ifdef __cplusplus
- (instancetype _Nullable)initWithConsumer:(mediasoupclient::Consumer *_Nonnull)consumer
	track:(RTCMediaStreamTrack *_Nonnull)track
	listenerAdapter:(ConsumerListenerAdapter *_Nonnull)listenerAdapter;
#endif


- (void)pause;

- (void)resume;

- (void)close;

- (NSString *_Nullable)getStatsWithError:(out NSError *__autoreleasing _Nullable *_Nullable)error;

@end

#endif /* ConsumerWrapper_h */
