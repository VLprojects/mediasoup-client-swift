#import <Foundation/Foundation.h>
#import <Producer.hpp>
#import <WebRTC/RTCMediaStreamTrack.h>
#import "ProducerWrapper.hpp"
#import "ProducerListenerAdapter.hpp"
#import "ProducerListenerAdapterDelegate.h"
#import "ProducerWrapperDelegate.h"
#import "WrappedRTPParameters.hpp"
#import "WrappedRTPParameters+Internal.hpp"
#import "RTPEncodingParameters.hpp"
#import "../MediasoupClientError/MediasoupClientErrorHandler.h"


@interface ProducerWrapper () <ProducerListenerAdapterDelegate> {
	mediasoupclient::Producer *_producer;
	ProducerListenerAdapter *_listenerAdapter;
}
@property(nonatomic, nonnull, readwrite) RTCMediaStreamTrack *track;
@end


@implementation ProducerWrapper

- (instancetype)initWithProducer:(mediasoupclient::Producer *_Nonnull)producer
	mediaStreamTrack:(RTCMediaStreamTrack *_Nonnull)track
	listenerAdapter:(ProducerListenerAdapter *_Nonnull)listenerAdapter {

	self = [super init];

	if (self != nil) {
		_producer = producer;
		_track = track;
		_listenerAdapter = listenerAdapter;
		_listenerAdapter->delegate = self;
	}

	return self;
}

- (void)dealloc {
	delete _producer;
	delete _listenerAdapter;
}

#pragma mark - Public methods

- (NSString *_Nonnull)id {
	return [NSString stringWithUTF8String:_producer->GetId().c_str()];
}

- (NSString *_Nonnull)localId {
	return [NSString stringWithUTF8String:_producer->GetLocalId().c_str()];
}

- (BOOL)closed {
	return _producer->IsClosed() == true;
}

- (BOOL)paused {
	return _producer->IsPaused() == true;
}

- (NSString *_Nonnull)kind {
	return [NSString stringWithUTF8String:_producer->GetKind().c_str()];
}

- (UInt8)maxSpatialLayer {
	return _producer->GetMaxSpatialLayer();
}

- (NSString *_Nonnull)appData {
	return [NSString stringWithUTF8String:_producer->GetAppData().dump().c_str()];
}

- (NSString *_Nonnull)rtpParameters {
	return [NSString stringWithUTF8String:_producer->GetRtpParameters().dump().c_str()];
}

- (NSString *_Nonnull)stats {
	return [NSString stringWithUTF8String:_producer->GetStats().dump().c_str()];
}

- (void)pause {
	_producer->Pause();
}

- (void)resume {
	_producer->Resume();
}

- (void)close {
	_producer->Close();
}

- (void)setMaxSpatialLayer:(UInt8)layer
	error:(out NSError *__autoreleasing _Nullable *_Nullable)error
	__attribute__((swift_error(nonnull_error))) {

	mediasoupTry(^{
		self->_producer->SetMaxSpatialLayer(layer);
	}, error);
}

- (void)updateRTPParameters:(WrappedRTPParameters *_Nonnull(^_Nonnull)(WrappedRTPParameters *_Nonnull))updater {
	webrtc::RtpSenderInterface *sender = self->_producer->GetRtpSender();
	webrtc::RtpParameters parameters = sender->GetParameters();
	WrappedRTPParameters *wrappedOldParameters = [[WrappedRTPParameters alloc]
		initWithEncodings: parameters.encodings
		degradationPreference: parameters.degradation_preference
	];
	WrappedRTPParameters *wrappedNewParameters = updater(wrappedOldParameters);
	parameters.degradation_preference = [wrappedNewParameters degradationPreference];
	for (int i = 0; i < wrappedNewParameters.wrappedEncodings.count; i++) {
		RTPEncodingParameters *updatedEncoding = wrappedNewParameters.wrappedEncodings[i];

		parameters.encodings[i].min_bitrate_bps = updatedEncoding.minBitrateBps
			? absl::make_optional(updatedEncoding.minBitrateBps.intValue)
			: absl::nullopt;

		parameters.encodings[i].max_bitrate_bps = updatedEncoding.maxBitrateBps
			? absl::make_optional(updatedEncoding.maxBitrateBps.intValue)
			: absl::nullopt;

		parameters.encodings[i].max_framerate = updatedEncoding.maxFramerate
			? absl::make_optional(updatedEncoding.maxFramerate.doubleValue)
			: absl::nullopt;

		parameters.encodings[i].scale_resolution_down_by = updatedEncoding.scaleResolutionDownBy
			? absl::make_optional(updatedEncoding.scaleResolutionDownBy.doubleValue)
			: absl::nullopt;

		webrtc::Resolution resolution = {
			.width = static_cast<int>(updatedEncoding.requestedResolution.width),
			.height = static_cast<int>(updatedEncoding.requestedResolution.height)
		};
		parameters.encodings[i].requested_resolution = resolution.PixelCount() > 0
			? absl::make_optional(resolution)
			: absl::nullopt;

		parameters.encodings[i].scalability_mode = updatedEncoding.scalabilityMode
			? absl::make_optional(std::string(updatedEncoding.scalabilityMode.UTF8String))
			: absl::nullopt;

		parameters.encodings[i].num_temporal_layers = updatedEncoding.numTemporalLayers
			? absl::make_optional(updatedEncoding.numTemporalLayers.intValue)
			: absl::nullopt;

		parameters.encodings[i].bitrate_priority = updatedEncoding.bitratePriority;
		parameters.encodings[i].adaptive_ptime = updatedEncoding.adaptiveAudioPacketTime;
	}

	sender->SetParameters(parameters);
}

- (void)replaceTrack:(RTCMediaStreamTrack *)track
	error:(out NSError *__autoreleasing _Nullable *_Nullable)error
	__attribute__((swift_error(nonnull_error))) {

	mediasoupTry(^{
		// RTCMediaStreamTrack `hash` returns pointer to native track object.
		auto mediaStreamTrack = (webrtc::MediaStreamTrackInterface *)[track hash];
		self->_producer->ReplaceTrack(mediaStreamTrack);
		self.track = track;
	}, error);
}

- (NSString *_Nullable)getStatsWithError:(out NSError *__autoreleasing _Nullable *_Nullable)error {
	return nil;
}

#pragma mark - ProducerListenerAdapterDelegate methods

- (void)onTransportClose:(ProducerListenerAdapter *_Nonnull)adapter {
	if (adapter != _listenerAdapter) {
		return;
	}

	[self.delegate onTransportClose:self];
}

@end
