#ifndef LoggerWrapper_h
#define LoggerWrapper_h

#import <Foundation/Foundation.h>

@interface LoggerWrapper : NSObject
+ (void)setLogLevel:(uint8_t)level;
+ (void)errorWithLog:(NSString *_Nonnull)log;
+ (void)warnWithLog:(NSString *_Nonnull)log;
+ (void)debugWithLog:(NSString *_Nonnull)log;
@end

#endif