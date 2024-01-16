#ifndef SendTransportWrapper_h
#define SendTransportWrapper_h

#import <Foundation/Foundation.h>

#ifdef __cplusplus
namespace mediasoupclient {
	class SendTransport;
}
class SendTransportListenerAdapter;
#endif

@class ProducerWrapper;
@class RTCMediaStreamTrack;
@class RTCRtpEncodingParameters;
@protocol SendTransportWrapperDelegate;


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

- (ProducerWrapper *_Nullable)createProducerForTrack:(RTCMediaStreamTrack *_Nonnull)mediaTrack
	encodings:(NSArray<RTCRtpEncodingParameters *> *_Nullable)encodings
	codecOptions:(NSString *_Nullable)codecOptions
	codec:(NSString *_Nullable)codec
	appData:(NSString *_Nullable)appData
	error:(out NSError *__autoreleasing _Nullable *_Nullable)error;

- (ProducerWrapper *_Nullable)createProducerForTrack:(RTCMediaStreamTrack *_Nonnull)mediaTrack
	encoding:(RTCRtpEncodingParameters *_Nonnull)encoding
	scalabilityMode:(NSString *_Nonnull)scalabilityMode
	codecOptions:(NSString *_Nullable)codecOptions
	codec:(NSString *_Nullable)codec
	appData:(NSString *_Nullable)appData
	error:(out NSError *__autoreleasing _Nullable *_Nullable)error;

@end

#endif /* SendTransportWrapper_h */
