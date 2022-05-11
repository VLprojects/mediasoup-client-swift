#ifndef ConsumerListenerAdapterDelegate_h
#define ConsumerListenerAdapterDelegate_h

#import <Foundation/Foundation.h>


class ConsumerListenerAdapter;


@protocol ConsumerListenerAdapterDelegate
@required
- (void)onTransportClose:(ConsumerListenerAdapter *_Nonnull)adapter;
@end

#endif /* ConsumerListenerAdapterDelegate_h */
