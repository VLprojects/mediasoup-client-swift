import Foundation


public enum MediasoupError: Error {
	case unsupported(String)
	case invalidState(String)
	case invalidParameters(String)
	case mediasoup(NSError)
	case unknown(Error)
}
