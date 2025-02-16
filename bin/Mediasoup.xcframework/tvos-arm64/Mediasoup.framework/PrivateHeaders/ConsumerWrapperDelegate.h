#ifndef ConsumerWrapperDelegate_h
#define ConsumerWrapperDelegate_h

#import <Foundation/Foundation.h>


@class ConsumerWrapper;


@protocol ConsumerWrapperDelegate
- (void)onTransportClose:(ConsumerWrapper *_Nonnull)consumer;
@end

#endif /* ConsumerWrapperDelegate_h */
