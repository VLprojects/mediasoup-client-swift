#import "WrappedRTPParameters+Internal.hpp"
#import "RTPEncodingParameters+Internal.hpp"
#include <api/rtp_parameters.h>


@implementation WrappedRTPParameters (Internal)

- (instancetype _Nonnull)initWithEncodings:(std::vector<webrtc::RtpEncodingParameters>)encodings degradationPreference:(absl::optional<webrtc::DegradationPreference>)degradationPreference {

	self = [super init];

	if (self == nil) {
		return nil;
	}

	NSMutableArray<RTPEncodingParameters *> *wrappedEncodings = [[NSMutableArray alloc] init];
	for (webrtc::RtpEncodingParameters encoding : encodings) {
		RTPEncodingParameters *wrappedEncoding = [[RTPEncodingParameters alloc] initWithValue:encoding];
		[wrappedEncodings addObject:wrappedEncoding];
	}
	self.wrappedEncodings = wrappedEncodings;

	if (degradationPreference.has_value()) {
		switch (degradationPreference.value()) {
			case webrtc::DegradationPreference::DISABLED:
				self.wrappedDegradationPreference = WrappedDegradationPreferenceDisabled;
			case webrtc::DegradationPreference::MAINTAIN_FRAMERATE:
				self.wrappedDegradationPreference = WrappedDegradationPreferenceMaintainFramerate;
			case webrtc::DegradationPreference::MAINTAIN_RESOLUTION:
				self.wrappedDegradationPreference = WrappedDegradationPreferenceMaintainResolution;
			case webrtc::DegradationPreference::BALANCED:
				self.wrappedDegradationPreference = WrappedDegradationPreferenceBalanced;
		}
	} else {
		self.wrappedDegradationPreference = WrappedDegradationPreferenceNone;
	}
	return self;
}

- (absl::optional<webrtc::DegradationPreference>)degradationPreference {
	switch (self.wrappedDegradationPreference) {
		case WrappedDegradationPreferenceNone:
			return absl::nullopt;
		case WrappedDegradationPreferenceDisabled:
			return absl::make_optional(webrtc::DegradationPreference::DISABLED);
		case WrappedDegradationPreferenceMaintainFramerate:
			return absl::make_optional(webrtc::DegradationPreference::MAINTAIN_FRAMERATE);
		case WrappedDegradationPreferenceMaintainResolution:
			return absl::make_optional(webrtc::DegradationPreference::MAINTAIN_RESOLUTION);
		case WrappedDegradationPreferenceBalanced:
			return absl::make_optional(webrtc::DegradationPreference::BALANCED);
	}
}

@end
