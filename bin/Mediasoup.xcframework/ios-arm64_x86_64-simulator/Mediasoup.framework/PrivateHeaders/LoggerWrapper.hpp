#ifndef LoggerWrapper_hpp
#define LoggerWrapper_hpp

#import <Foundation/Foundation.h>
#import "MediasoupClientLogLevel.h"


@protocol LogHandlerWrapper;


@interface LoggerWrapper : NSObject

@property (class, nonatomic) MediasoupClientLogLevel logLevel;

+ (void)setHandler:(id<LogHandlerWrapper>)adapterDelegate;

+ (void)setDefaultHandler;

@end

#endif /* LoggerWrapper_hpp */
