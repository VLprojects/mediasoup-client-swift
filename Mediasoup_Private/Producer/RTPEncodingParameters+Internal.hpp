#ifndef RTPEncodingParameters_Internal_h
#define RTPEncodingParameters_Internal_h

#import "RTPEncodingParameters.hpp"

namespace webrtc {
	struct RtpEncodingParameters;
}

@interface RTPEncodingParameters (Internal)
- (instancetype _Nonnull)initWithValue:(webrtc::RtpEncodingParameters)value;
@end


#endif /* RTPEncodingParameters_Internal_h */
