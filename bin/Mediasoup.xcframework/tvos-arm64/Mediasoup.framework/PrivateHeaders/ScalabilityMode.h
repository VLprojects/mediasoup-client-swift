#ifndef ScalabilityMode_h
#define ScalabilityMode_h

#import <Foundation/Foundation.h>


@interface ScalabilityMode: NSObject
@property(nonatomic, readonly) int spatialLayers;
@property(nonatomic, readonly) int temporalLayers;
+ (instancetype _Nonnull)parseScalabilityMode:(NSString *_Nonnull)scalabilityMode;
@end

#endif /* ScalabilityMode_h */
