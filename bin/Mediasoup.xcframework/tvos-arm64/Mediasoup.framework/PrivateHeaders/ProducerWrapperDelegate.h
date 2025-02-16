#ifndef ProducerWrapperDelegate_h
#define ProducerWrapperDelegate_h

#import <Foundation/Foundation.h>


@class ProducerWrapper;


@protocol ProducerWrapperDelegate
- (void)onTransportClose:(ProducerWrapper *_Nonnull)producer;
@end

#endif /* ProducerWrapperDelegate_h */
