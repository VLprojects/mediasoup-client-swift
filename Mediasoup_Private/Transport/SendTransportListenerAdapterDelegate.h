#ifndef SendTransportListenerAdapterDelegate_h
#define SendTransportListenerAdapterDelegate_h

#import "TransportListenerAdapterDelegate.h"


@protocol SendTransportListenerAdapterDelegate <TransportListenerAdapterDelegate>
@required
- (void)onProduce:(NSString *)transportId
	kind:(NSString *)kind
	rtpParameters:(NSString *)rtpParameters
	appData:(NSString *)appData
	callback:(void(^)(NSString *))callback;
@end

#endif /* SendTransportListenerAdapterDelegate_h */
