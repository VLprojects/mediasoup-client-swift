#ifndef WrappedRTPParametersWrapper_h
#define WrappedRTPParametersWrapper_h

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WrappedDegradationPreference) {
	WrappedDegradationPreferenceNone,
	WrappedDegradationPreferenceDisabled,
	WrappedDegradationPreferenceMaintainFramerate,
	WrappedDegradationPreferenceMaintainResolution,
	WrappedDegradationPreferenceBalanced,
};

@class RTPEncodingParameters;

@interface WrappedRTPParameters : NSObject
@property (nonatomic, assign) WrappedDegradationPreference wrappedDegradationPreference;
@property (nonatomic, nullable, copy) NSArray<RTPEncodingParameters *> *wrappedEncodings;
@end

#endif /* WrappedRTPParametersWrapper_h */
