#ifndef DataConsumerWrapperDelegate_h
#define DataConsumerWrapperDelegate_h

#import <Foundation/Foundation.h>


@class DataConsumerWrapper;


@protocol DataConsumerWrapperDelegate
- (void)onMessage:(NSData *_Nonnull)messageData consumer:(DataConsumerWrapper *_Nonnull)consumer;
- (void)onConnecting:(DataConsumerWrapper *_Nonnull)consumer;
- (void)onOpen:(DataConsumerWrapper *_Nonnull)consumer;
- (void)onClosing:(DataConsumerWrapper *_Nonnull)consumer;
- (void)onClose:(DataConsumerWrapper *_Nonnull)consumer;
- (void)onTransportClose:(DataConsumerWrapper *_Nonnull)consumer;
@end

#endif /* DataConsumerWrapperDelegate_h */
