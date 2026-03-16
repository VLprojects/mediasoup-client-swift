#ifndef DataProducerWrapper_h
#define DataProducerWrapper_h

#import <Foundation/Foundation.h>

#ifdef __cplusplus
namespace mediasoupclient {
	class DataProducer;
}
class DataProducerListenerAdapter;
#endif

typedef NS_ENUM(NSUInteger, WrappedDataState);
@protocol DataProducerWrapperDelegate;

@interface DataProducerWrapper : NSObject

@property(nonatomic, nullable, weak) id<DataProducerWrapperDelegate> delegate;
@property(nonatomic, nonnull, readonly, getter = id) NSString *id;
@property(nonatomic, nonnull, readonly, getter = localId) NSString *localId;
@property(nonatomic, nonnull, readonly, getter = sctpStreamParameters) NSString *sctpStreamParameters;
@property(nonatomic, readonly, getter = readyState) WrappedDataState readyState;
@property(nonatomic, nonnull, readonly, getter = label) NSString *label;
@property(nonatomic, nonnull, readonly, getter = protocol) NSString *protocol;
@property(nonatomic, readonly, getter = bufferedAmount) UInt64 bufferedAmount;
@property(nonatomic, nonnull, readonly, getter = appData) NSString *appData;
@property(nonatomic, readonly, getter = closed) BOOL closed;

#ifdef __cplusplus
- (instancetype _Nullable)initWithDataProducer:(mediasoupclient::DataProducer *_Nonnull)producer
	listenerAdapter:(DataProducerListenerAdapter *_Nonnull)listenerAdapter;
#endif

- (void)send:(NSData *_Nonnull)buffer;

- (void)close;

@end

#endif /* DataProducerWrapper_h */
