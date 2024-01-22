#ifndef RTPEncodingParameters_h
#define RTPEncodingParameters_h

#import <Foundation/Foundation.h>


@interface RTPEncodingParameters : NSObject
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, nullable, strong) NSNumber *minBitrateBps;
@property (nonatomic, nullable, strong) NSNumber *maxBitrateBps;
@property (nonatomic, nullable, strong) NSNumber *maxFramerate;
@property (nonatomic, nullable, strong) NSNumber *scaleResolutionDownBy;
@property (nonatomic, assign) CGSize requestedResolution;
@property (nonatomic, nullable, copy) NSString *scalabilityMode;
@property (nonatomic, nullable, strong) NSNumber *numTemporalLayers;
@property (nonatomic, assign) double bitratePriority;
@property (nonatomic, assign) BOOL adaptiveAudioPacketTime;
@end

#endif /* RTPEncodingParameters_h */
