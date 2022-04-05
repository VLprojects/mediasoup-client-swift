#ifndef TransportListenerAdapterDelegate_h
#define TransportListenerAdapterDelegate_h

#import <Foundation/Foundation.h>


@protocol TransportListenerAdapterDelegate <NSObject>
@required
- (void)onConnect:(NSString *)transportId dtlsParameters:(NSString *)dtlsParameters;
- (void)onConnectionStateChange:(NSString *)transportId connectionState:(NSString *)connectionState;
@end

#endif /* TransportListenerAdapterDelegate_h */
