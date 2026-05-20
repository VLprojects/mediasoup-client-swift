import Foundation
import Mediasoup_Private


public enum MediasoupClient {
	public static func initialize() {
		MediasoupClientWrapper.initialize()
	}

	public static func cleanup() {
		MediasoupClientWrapper.cleanup()
	}

	public static var version: String {
		return MediasoupClientWrapper.version()
	}
}
