import Foundation
import Mediasoup_Private


public struct RTPParameters {
	public enum DegradationPreference {
		// Don't take any actions based on over-utilization signals. Not part of the
		// web API.
		case disabled

		// On over-use, request lower resolution, possibly causing down-scaling.
		case maintainFramerate

		// On over-use, request lower frame rate, possibly causing frame drops.
		case maintainResolution

		// Try to strike a "pleasing" balance between frame rate or resolution.
		case balanced

		internal var wrappedValue: WrappedDegradationPreference {
			switch self {
				case .disabled:
					return .disabled
				case .maintainFramerate:
					return .maintainFramerate
				case .maintainResolution:
					return .maintainResolution
				case .balanced:
					return .balanced
			}
		}

		internal init?(from value: WrappedDegradationPreference) {
			switch value {
				case .none:
					return nil
				case .disabled:
					self = .disabled
				case .maintainFramerate:
					self = .maintainFramerate
				case .maintainResolution:
					self = .maintainResolution
				case .balanced:
					self = .balanced
				@unknown default:
					return nil
			}
		}
	}

	public struct RTPEncodingParameters {
		public struct Resolution {
			public var width: Int
			public var height: Int

			public var cgSizeValue: CGSize {
				CGSize(width: width, height: height)
			}

			public init(width: Int, height: Int) {
				self.width = width
				self.height = height
			}

			public init(from cgSize: CGSize) {
				self.width = Int(cgSize.width)
				self.height = Int(cgSize.height)
			}
		}

		public var scalabilityMode: String?

		/// Requested encode resolution.
		///
		/// This field provides an alternative to `scaleResolutionDownBy`
		/// that is not dependent on the video source.
		///
		/// The `requestedResolution` is subject to resource adaptation.
		///
		/// It is an error to set both `requestedResolution` and
		/// `scaleResolutionDownBy`.
		public var requestedResolution: Resolution?

		/// Controls whether the encoding is currently transmitted.
		public var isActive: Bool

		/// The maximum bitrate to use for the encoding, or nil if there is no limit.
		public var maxBitrateBps: Int?

		/// The minimum bitrate to use for the encoding, or nil if there is no limit.
		public var minBitrateBps: Int?

		/// The maximum framerate to use for the encoding, or nil if there is no limit.
		public var maxFramerate: Double?

		/// The requested number of temporal layers to use for the encoding,
		/// or nil if the default should be used.
		public var numTemporalLayers: Int?

		/// Scale the width and height down by this factor for video.
		/// If nil, implementation default scaling factor will be used.
		public var scaleResolutionDownBy: Double?

		/// The relative bitrate priority.
		public var bitratePriority: Double

		/// Allow dynamic frame length changes for audio:
		/// https://w3c.github.io/webrtc-extensions/#dom-rtcrtpencodingparameters-adaptiveptime
		public var adaptiveAudioPacketTime: Bool

		internal var wrappedValue: Mediasoup_Private.RTPEncodingParameters {
			let value = Mediasoup_Private.RTPEncodingParameters()
			value.isActive = isActive
			if let minBitrateBps {
				value.minBitrateBps = NSNumber(value: minBitrateBps)
			} else {
				value.minBitrateBps = nil
			}
			if let maxBitrateBps {
				value.maxBitrateBps = NSNumber(value: maxBitrateBps)
			} else {
				value.maxBitrateBps = nil
			}
			if let maxFramerate {
				value.maxFramerate = NSNumber(value: maxFramerate)
			} else {
				value.maxFramerate = nil
			}
			value.adaptiveAudioPacketTime = adaptiveAudioPacketTime
			value.bitratePriority = bitratePriority

			if let numTemporalLayers {
				value.numTemporalLayers = NSNumber(value: numTemporalLayers)
			} else {
				value.numTemporalLayers = nil
			}

			value.requestedResolution = requestedResolution?.cgSizeValue ?? .zero

			value.scalabilityMode = scalabilityMode

			if let scaleResolutionDownBy {
				value.scaleResolutionDownBy = NSNumber(value: scaleResolutionDownBy)
			} else {
				value.scaleResolutionDownBy = nil
			}

			return value
		}

		internal init(from value: Mediasoup_Private.RTPEncodingParameters) {
			self.isActive = value.isActive
			self.minBitrateBps = value.minBitrateBps?.intValue
			self.maxBitrateBps = value.maxBitrateBps?.intValue
			self.maxFramerate = value.maxFramerate?.doubleValue
			self.adaptiveAudioPacketTime = value.adaptiveAudioPacketTime
			self.bitratePriority = value.bitratePriority
			self.numTemporalLayers = value.numTemporalLayers?.intValue

			if value.requestedResolution == .zero {
				self.requestedResolution = nil
			} else {
				self.requestedResolution = Resolution(from: value.requestedResolution)
			}

			self.scalabilityMode = value.scalabilityMode
			self.scaleResolutionDownBy = value.scaleResolutionDownBy?.doubleValue
		}
	}

	public var degradationPreference: DegradationPreference?
	public var encodings: [RTPEncodingParameters]?

	internal var wrappedValue: WrappedRTPParameters {
		let value = WrappedRTPParameters()
		value.wrappedDegradationPreference = degradationPreference?.wrappedValue ?? .none
		value.wrappedEncodings = encodings?.map({ $0.wrappedValue })
		return value
	}

	internal init(from value: WrappedRTPParameters) {
		self.degradationPreference = DegradationPreference(from: value.wrappedDegradationPreference)
		self.encodings = value.wrappedEncodings?.map({ RTPEncodingParameters(from: $0) })
	}
}
