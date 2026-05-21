import Foundation
import Mediasoup_Private


public enum Logger {
	public static var logLevel: LogLevel {
		get { LoggerWrapper.logLevel.swiftValue }
		set { LoggerWrapper.logLevel = newValue.objcValue }
	}

	private static var handlerHolder: HandlerHolder?

	public static func setHandler(_ handler: any LogHandler) {
		let handlerHolder = HandlerHolder(handler: handler)
		Self.handlerHolder = handlerHolder
		LoggerWrapper.setHandler(handlerHolder)
	}

	public static func setDefaultHandler() {
		Self.handlerHolder = nil
		LoggerWrapper.setDefaultHandler()
	}
}

// MARK: - LogHandlerAdapterDelegate implementation

extension HandlerHolder: LogHandlerWrapper {
	public func onLog(_ level: MediasoupClientLogLevel, payload: String) {
		handler.onLog(level: level.swiftValue, payload: payload)
	}
}

final class HandlerHolder {
	let handler: LogHandler

	init(handler: LogHandler) {
		self.handler = handler
	}
}
