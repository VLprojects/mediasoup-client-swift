#ifndef SendTransportWrapperDelegate_h
#define SendTransportWrapperDelegate_h

#import <Foundation/Foundation.h>
#import "MediasoupClientTransportConnectionState.h"


@class SendTransportWrapper;


@protocol SendTransportWrapperDelegate
- (void)onConnect:(SendTransportWrapper *_Nonnull)transport
	dtlsParameters:(NSString *_Nonnull)dtlsParameters;

- (void)onConnectionStateChange:(SendTransportWrapper *_Nonnull)transport
	connectionState:(MediasoupClientTransportConnectionState _Nonnull)connectionState;

- (void)onProduce:(SendTransportWrapper *_Nonnull)transport
	kind:(NSString *_Nonnull)kind
	rtpParameters:(NSString *_Nonnull)rtpParameters
	appData:(NSString *_Nonnull)appData
	callback:(void(^_Nonnull)(NSString *_Nullable))callback;

- (void)onProduceData:(SendTransportWrapper *_Nonnull)transport
	sctpParameters:(NSString *_Nonnull)sctpParameters
	label:(NSString *_Nonnull)label
	protocol:(NSString *_Nonnull)protocol
	appData:(NSString *_Nonnull)appData
	callback:(void(^_Nonnull)(NSString *_Nullable))callback;
@end

#endif /* SendTransportWrapperDelegate_h */
