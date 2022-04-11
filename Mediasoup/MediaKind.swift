import Foundation
import Mediasoup_Private


public enum MediaKind {
	case audio
	case video
}

internal extension MediaKind {
	var mediaClientValue: MediasoupClientMediaKind {
		switch self {
			case .audio: return .audio
			case .video: return .video
		}
	}

	init?(stringValue: String) {
		switch MediasoupClientMediaKind(rawValue: stringValue) {
			case .audio:
				self = .audio

			case .video:
				self = .video

			default:
				return nil
		}
	}
}
