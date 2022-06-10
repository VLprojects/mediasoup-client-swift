import Foundation
import Mediasoup_Private


public enum TransportConnectionState {
	case new
	case checking
	case connected
	case completed
	case failed
	case disconnected
	case closed
}

internal extension TransportConnectionState {
	var mediaClientValue: MediasoupClientTransportConnectionState {
		switch self {
			case .new: return .new
			case .checking: return .checking
			case .connected: return .connected
			case .completed: return .completed
			case .failed: return .failed
			case .disconnected: return .disconnected
			case .closed: return .closed
		}
	}

	init?(stringValue: String) {
		switch MediasoupClientTransportConnectionState(rawValue: stringValue) {
			case .new: self = .new
			case .checking: self = .checking
			case .connected: self = .connected
			case .completed: self = .completed
			case .failed: self = .failed
			case .disconnected: self = .disconnected
			case .closed: self = .closed
			default: return nil
		}
	}
}
