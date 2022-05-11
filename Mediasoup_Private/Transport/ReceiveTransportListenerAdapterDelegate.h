#ifndef ReceiveTransportListenerAdapterDelegate_h
#define ReceiveTransportListenerAdapterDelegate_h

#import <Foundation/Foundation.h>


class ReceiveTransportListenerAdapter;


@protocol ReceiveTransportListenerAdapterDelegate
@required

- (void)onConnect:(ReceiveTransportListenerAdapter *_Nonnull)adapter
	dtlsParameters:(NSString *_Nonnull)dtlsParameters;

- (void)onConnectionStateChange:(ReceiveTransportListenerAdapter *_Nonnull)adapter
	connectionState:(NSString *_Nonnull)connectionState;

@end

#endif /* ReceiveTransportListenerAdapterDelegate_h */
