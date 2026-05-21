import Mediasoup_Private


public enum LogLevel {
	case none
	case error
	case warning
	case debug
	case trace
}

internal extension LogLevel {
	var objcValue: MediasoupClientLogLevel {
		switch self {
			case .none: return .none
			case .error: return .error
			case .warning: return .warning
			case .debug: return .debug
			case .trace: return .trace
		}
	}
}

internal extension MediasoupClientLogLevel {
	var swiftValue: LogLevel {
		switch self {
			case .none: return .none
			case .error: return .error
			case .warning: return .warning
			case .debug: return .debug
			case .trace: return .trace
			@unknown default: fatalError("Unexpected value")
		}
	}
}
