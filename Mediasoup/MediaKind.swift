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
}
