#ifndef RTPParametersWrapper_Internal_h
#define RTPParametersWrapper_Internal_h

#import "WrappedRTPParameters.hpp"

#ifdef __cplusplus

#include "absl/types/optional.h"

namespace webrtc {
	enum class DegradationPreference;
	struct RtpEncodingParameters;
}

#endif /* __cplusplus */


@interface WrappedRTPParameters (Internal)
#ifdef __cplusplus
- (instancetype _Nonnull)initWithEncodings:(std::vector<webrtc::RtpEncodingParameters>)encodings degradationPreference:(absl::optional<webrtc::DegradationPreference>)degradationPreference;
- (absl::optional<webrtc::DegradationPreference>)degradationPreference;
#endif  /* __cplusplus */
@end

#endif /* RTPParametersWrapper_Internal_h */
