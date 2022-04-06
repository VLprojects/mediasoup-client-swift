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

#ifdef __cplusplus
- (instancetype _Nullable)initWithTransport:(mediasoupclient::SendTransport *_Nonnull)transport
	listenerAdapter:(SendTransportListenerAdapter *_Nonnull)listenerAdapter;
#endif

@end

#endif /* SendTransportWrapper_h */
