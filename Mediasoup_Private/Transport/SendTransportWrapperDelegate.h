#ifndef SendTransportWrapperDelegate_h
#define SendTransportWrapperDelegate_h

#import <Foundation/Foundation.h>


@protocol SendTransportWrapperDelegate
- (void)onConnect:(NSString *)transportId
	dtlsParameters:(NSString *)dtlsParameters;

- (void)onConnectionStateChange:(NSString *)transportId
	connectionState:(NSString *)connectionState;

- (void)onProduce:(NSString *)transportId
	kind:(NSString *)kind
	rtpParameters:(NSString *)rtpParameters
	appData:(NSString *)appData
	callback:(void(^)(NSString *))callback;

@end

#endif /* SendTransportWrapperDelegate_h */
