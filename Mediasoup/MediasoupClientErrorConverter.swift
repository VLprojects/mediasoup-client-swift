import Foundation
import Mediasoup_Private


private func description(_ error: MediasoupClientError) -> String {
	let description = error.errorUserInfo[NSLocalizedDescriptionKey] as? String
	return description ?? String()
}

internal func convertMediasoupErrors<T>(_ throwingClosure: () throws -> T) throws -> T {
	do {
		return try throwingClosure()
	} catch let error as MediasoupClientError {
		switch error.code {
			case .unsupported:
				throw MediasoupError.unsupported(description(error))
			case .invalidParameters:
				throw MediasoupError.invalidParameters(description(error))
			case .invalidState:
				throw MediasoupError.invalidState(description(error))
			case .unknown:
				if let underlyingError = error.errorUserInfo[NSUnderlyingErrorKey] as? NSError {
					throw MediasoupError.mediasoup(underlyingError)
				} else {
					throw MediasoupError.unknown(error)
				}
			@unknown default:
				throw MediasoupError.unknown(error)
		}
	} catch {
		throw MediasoupError.unknown(error)
	}
}
