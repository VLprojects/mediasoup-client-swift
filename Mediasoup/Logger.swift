import Foundation
import Mediasoup_Private

public class Logger {
    public static func setLogLevel(with level: UInt8) {
        LoggerWrapper.setLogLevel(level)
    }

    public static func error(_ log: String) {
        LoggerWrapper.error(withLog: log)
    }

    public static func warn(_ log: String) {
        LoggerWrapper.warn(withLog: log)
    }

    public static func debug(_ log: String) {
        LoggerWrapper.debug(withLog: log)
    }
}
