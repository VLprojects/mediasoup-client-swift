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

@property(nonatomic, weak) id<SendTransportWrapperDelegate> delegate;

#ifdef __cplusplus
- (instancetype)initWithTransport:(mediasoupclient::SendTransport *)transport
	listenerAdapter:(SendTransportListenerAdapter *)listenerAdapter;
#endif

@end

#endif /* SendTransportWrapper_h */
