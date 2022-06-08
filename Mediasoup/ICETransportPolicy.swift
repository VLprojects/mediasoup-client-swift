import Foundation
import WebRTC


public enum ICETransportPolicy {
	case none
	case relay
	case noHost
	case all

	internal var rtcICETransportPolicy: RTCIceTransportPolicy {
		switch self {
			case .none:
				return .none
			case .relay:
				return .relay
			case .noHost:
				return .noHost
			case .all:
				return .all
		}
	}
}
