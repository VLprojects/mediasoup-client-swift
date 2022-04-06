#ifndef SendTransportListenerAdapterDelegate_h
#define SendTransportListenerAdapterDelegate_h

#import <Foundation/Foundation.h>


class SendTransportListenerAdapter;


@protocol SendTransportListenerAdapterDelegate
@required

- (void)onConnect:(SendTransportListenerAdapter *_Nonnull)adapter
	dtlsParameters:(NSString *_Nonnull)dtlsParameters;

- (void)onConnectionStateChange:(SendTransportListenerAdapter *_Nonnull)adapter
	connectionState:(NSString *_Nonnull)connectionState;

- (void)onProduce:(SendTransportListenerAdapter *_Nonnull)adapter
	kind:(NSString *_Nonnull)kind
	rtpParameters:(NSString *_Nonnull)rtpParameters
	appData:(NSString *_Nonnull)appData
	callback:(void(^_Nonnull)(NSString *_Nullable))callback;

- (void)onProduceData:(SendTransportListenerAdapter *_Nonnull)adapter
	sctpParameters:(NSString *_Nonnull)sctpParameters
	label:(NSString *_Nonnull)label
	protocol:(NSString *_Nonnull)protocol
	appData:(NSString *_Nonnull)appData
	callback:(void(^_Nonnull)(NSString *_Nullable))callback;

@end

#endif /* SendTransportListenerAdapterDelegate_h */
