#ifndef MediasoupClient_hpp
#define MediasoupClient_hpp

#import <Foundation/Foundation.h>


@interface MediasoupClientWrapper : NSObject 

+ (void)initialize;

+ (void)cleanup;

+ (NSString *_Nonnull)version;

@end

#endif /* MediasoupClient_hpp */
