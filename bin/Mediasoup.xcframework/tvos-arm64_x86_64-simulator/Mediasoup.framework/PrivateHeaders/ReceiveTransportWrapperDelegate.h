#ifndef ReceiveTransportWrapperDelegate_h
#define ReceiveTransportWrapperDelegate_h

#import <Foundation/Foundation.h>
#import "MediasoupClientTransportConnectionState.h"


@class ReceiveTransportWrapper;


@protocol ReceiveTransportWrapperDelegate
- (void)onConnect:(ReceiveTransportWrapper *_Nonnull)transport
	dtlsParameters:(NSString *_Nonnull)dtlsParameters;

- (void)onConnectionStateChange:(ReceiveTransportWrapper *_Nonnull)transport
	connectionState:(MediasoupClientTransportConnectionState _Nonnull)connectionState;

@end

#endif /* ReceiveTransportWrapperDelegate_h */
