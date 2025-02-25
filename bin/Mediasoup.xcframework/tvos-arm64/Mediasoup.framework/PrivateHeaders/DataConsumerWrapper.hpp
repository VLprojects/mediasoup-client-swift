#ifndef DataConsumerWrapper_h
#define DataConsumerWrapper_h

#import <Foundation/Foundation.h>

#ifdef __cplusplus
namespace mediasoupclient {
	class DataConsumer;
}
class DataConsumerListenerAdapter;
#endif

@protocol DataConsumerWrapperDelegate;


@interface DataConsumerWrapper : NSObject

@property(nonatomic, nullable, weak) id<DataConsumerWrapperDelegate> delegate;
@property(nonatomic, nonnull, readonly, getter = id) NSString *id;
@property(nonatomic, nonnull, readonly, getter = localId) NSString *localId;
@property(nonatomic, nonnull, readonly, getter = producerId) NSString *producerId;
@property(nonatomic, nonnull, readonly, getter = sctpStreamParameters) NSString *sctpStreamParameters;
@property(nonatomic, readonly, getter = closed) BOOL closed;
@property(nonatomic, nonnull, readonly, getter = label) NSString *label;
@property(nonatomic, nonnull, readonly, getter = dataProtocol) NSString *dataProtocol;
@property(nonatomic, nonnull, readonly, getter = appData) NSString *appData;

#ifdef __cplusplus
- (instancetype _Nullable)initWithDataConsumer:(mediasoupclient::DataConsumer *_Nonnull)consumer
	listenerAdapter:(DataConsumerListenerAdapter *_Nonnull)listenerAdapter;
#endif

- (void)close;

@end

#endif /* DataConsumerWrapper_h */
