#ifndef ProducerWrapper_h
#define ProducerWrapper_h

#import <Foundation/Foundation.h>

#ifdef __cplusplus
namespace mediasoupclient {
	class Producer;
}
class ProducerListenerAdapter;
#endif

@protocol ProducerWrapperDelegate;


@interface ProducerWrapper : NSObject

@property(nonatomic, nullable, weak) id<ProducerWrapperDelegate> delegate;

#ifdef __cplusplus
- (instancetype _Nullable)initWithProducer:(mediasoupclient::Producer *_Nonnull)producer
	listenerAdapter:(ProducerListenerAdapter *_Nonnull)listenerAdapter;
#endif

@end

#endif /* ProducerWrapper_h */
