#ifndef DataConsumerListenerAdapterDelegate_h
#define DataConsumerListenerAdapterDelegate_h

#import <Foundation/Foundation.h>


class DataConsumerListenerAdapter;


@protocol DataConsumerListenerAdapterDelegate
@required
- (void)onMessage:(NSData *_Nonnull)messageData from:(DataConsumerListenerAdapter *_Nonnull)adapter;
- (void)onConnecting:(DataConsumerListenerAdapter *_Nonnull)adapter;
- (void)onOpen:(DataConsumerListenerAdapter *_Nonnull)adapter;
- (void)onClosing:(DataConsumerListenerAdapter *_Nonnull)adapter;
- (void)onClose:(DataConsumerListenerAdapter *_Nonnull)adapter;
- (void)onTransportClose:(DataConsumerListenerAdapter *_Nonnull)adapter;
@end

#endif /* DataConsumerListenerAdapterDelegate_h */
