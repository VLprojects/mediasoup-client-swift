import Foundation


public enum MediasoupError: LocalizedError {
	case unsupported(String)
	case invalidState(String)
	case invalidParameters(String)
	case mediasoup(NSError)
        case unknown(String)
    
        public var errorDescription: String? {
            switch self {
            case .unsupported(let message):
                return "Unsupported: \(message)"
            case .invalidState(let message):
                return "Invalid State: \(message)"
            case .invalidParameters(let message):
                return "Invalid Parameters: \(message)"
            case .mediasoup(let error):
                return error.localizedDescription
            case .unknown(let message):
                return message
            }
        }
}
