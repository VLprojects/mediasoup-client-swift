#import "RTPEncodingParameters+Internal.hpp"
#import <api/rtp_parameters.h>


@implementation RTPEncodingParameters (Internal)

- (instancetype _Nonnull)initWithValue:(webrtc::RtpEncodingParameters)value {
	self = [super init];

	if (self == nil) {
		return nil;
	}

	self.isActive = value.active;

	if (value.min_bitrate_bps.has_value()) {
		self.minBitrateBps = [NSNumber numberWithInt:value.min_bitrate_bps.value()];
	} else {
		self.minBitrateBps = nil;
	}

	if (value.max_bitrate_bps.has_value()) {
		self.maxBitrateBps = [NSNumber numberWithInt:value.max_bitrate_bps.value()];
	} else {
		self.maxBitrateBps = nil;
	}

	if (value.max_framerate.has_value()) {
		self.maxFramerate = [NSNumber numberWithDouble:value.max_framerate.value()];
	} else {
		self.maxFramerate = nil;
	}

	if (value.scale_resolution_down_by.has_value()) {
		self.scaleResolutionDownBy = [NSNumber numberWithDouble:value.scale_resolution_down_by.value()];
	} else {
		self.scaleResolutionDownBy = nil;
	}

	if (value.requested_resolution.has_value()) {
		self.requestedResolution = {
			.width = static_cast<CGFloat>(value.requested_resolution.value().width),
			.height = static_cast<CGFloat>(value.requested_resolution.value().height),
		};
	} else {
		self.requestedResolution = {0, 0};
	}

	if (value.scalability_mode.has_value()) {
		self.scalabilityMode = [NSString stringWithUTF8String:value.scalability_mode.value().c_str()];
	} else {
		self.scalabilityMode = nil;
	}

	if (value.num_temporal_layers.has_value()) {
		self.numTemporalLayers = [NSNumber numberWithInt:value.num_temporal_layers.value()];
	} else {
		self.numTemporalLayers = nil;
	}

	self.bitratePriority = value.bitrate_priority;
	self.adaptiveAudioPacketTime = value.adaptive_ptime;

	return self;
}

@end
