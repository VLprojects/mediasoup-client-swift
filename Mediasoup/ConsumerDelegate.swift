import Foundation


public protocol ConsumerDelegate: AnyObject {
	func onTransportClose(in consumer: Consumer)
}
