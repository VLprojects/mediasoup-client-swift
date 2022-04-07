#ifndef ProducerListenerAdapterDelegate_h
#define ProducerListenerAdapterDelegate_h

#import <Foundation/Foundation.h>


class ProducerListenerAdapter;


@protocol ProducerListenerAdapterDelegate
@required
- (void)onTransportClose:(ProducerListenerAdapter *_Nonnull)adapter;
@end

#endif /* ProducerListenerAdapterDelegate_h */
