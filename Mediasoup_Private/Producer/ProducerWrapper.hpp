#ifndef ProducerWrapper_h
#define ProducerWrapper_h

#import <Foundation/Foundation.h>

#ifdef __cplusplus
namespace mediasoupclient {
	class Producer;
}
class ProducerListenerAdapter;
#endif

@class RTCMediaStreamTrack;
@protocol ProducerWrapperDelegate;


@interface ProducerWrapper : NSObject

@property(nonatomic, nullable, weak) id<ProducerWrapperDelegate> delegate;
@property(nonatomic, nonnull, readonly) RTCMediaStreamTrack *track;
@property(nonatomic, nonnull, readonly, getter = id) NSString *id;
@property(nonatomic, nonnull, readonly, getter = localId) NSString *localId;
@property(nonatomic, readonly, getter = closed) BOOL closed;
@property(nonatomic, readonly, getter = paused) BOOL paused;
@property(nonatomic, nonnull, readonly, getter = kind) NSString *kind;
@property(nonatomic, readonly, getter = maxSpatialLayer) UInt8 maxSpatialLayer;
@property(nonatomic, nonnull, readonly, getter = appData) NSString *appData;
@property(nonatomic, nonnull, readonly, getter = rtpParameters) NSString *rtpParameters;
@property(nonatomic, nonnull, readonly, getter = stats) NSString *stats;

#ifdef __cplusplus
- (instancetype _Nullable)initWithProducer:(mediasoupclient::Producer *_Nonnull)producer
	mediaStreamTrack:(RTCMediaStreamTrack *_Nonnull)track
	listenerAdapter:(ProducerListenerAdapter *_Nonnull)listenerAdapter;
#endif


- (void)pause;

- (void)resume;

- (void)close;

- (void)setMaxSpatialLayer:(UInt8)layer
	error:(out NSError *__autoreleasing _Nullable *_Nullable)error
	__attribute__((swift_error(nonnull_error)));

- (void)replaceTrack:(RTCMediaStreamTrack *_Nonnull)track
	error:(out NSError *__autoreleasing _Nullable *_Nullable)error
	__attribute__((swift_error(nonnull_error)));

- (NSString *_Nullable)getStatsWithError:(out NSError *__autoreleasing _Nullable *_Nullable)error;

@end

#endif /* ProducerWrapper_h */
