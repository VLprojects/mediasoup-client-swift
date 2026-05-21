public protocol LogHandler {
	func onLog(level: LogLevel, payload: String)
}
