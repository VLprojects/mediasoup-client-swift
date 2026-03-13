#ifndef DataProducerListenerAdapterDelegate_h
#define DataProducerListenerAdapterDelegate_h

#import <Foundation/Foundation.h>


class DataProducerListenerAdapter;


@protocol DataProducerListenerAdapterDelegate

@required
- (void)onOpen:(DataProducerListenerAdapter *_Nonnull)adapter;
- (void)onClose:(DataProducerListenerAdapter *_Nonnull)adapter;
- (void)onBufferedAmountChange:(DataProducerListenerAdapter *_Nonnull)adapter dataSize:(uint64_t)sentDataSize;
- (void)onTransportClose:(DataProducerListenerAdapter *_Nonnull)adapter;
@end

#endif /* DataProducerListenerAdapterDelegate_h */
