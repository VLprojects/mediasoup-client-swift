#ifndef DataProducerWrapperDelegate_h
#define DataProducerWrapperDelegate_h

#import <Foundation/Foundation.h>


@class DataProducerWrapper;


@protocol DataProducerWrapperDelegate
- (void)onOpen:(DataProducerWrapper *_Nonnull)adapter;
- (void)onClose:(DataProducerWrapper *_Nonnull)adapter;
- (void)onBufferedAmountChange:(DataProducerWrapper *_Nonnull)adapter dataSize:(uint64_t)sentDataSize;
- (void)onTransportClose:(DataProducerWrapper *_Nonnull)producer;
@end

#endif /* DataProducerWrapperDelegate_h */
