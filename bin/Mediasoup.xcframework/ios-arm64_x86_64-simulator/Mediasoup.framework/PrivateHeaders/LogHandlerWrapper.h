#ifndef LogHandlerWrapper_h
#define LogHandlerWrapper_h

#import <Foundation/Foundation.h>
#import "MediasoupClientLogLevel.h"


@protocol LogHandlerWrapper
@required
- (void)onLog:(MediasoupClientLogLevel)level payload:(NSString *_Nonnull)payload;
@end

#endif /* LogHandlerWrapper_h */
