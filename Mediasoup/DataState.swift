import Foundation


/// Wrapper for https://www.w3.org/TR/webrtc/#idl-def-rtcdatachannelstate
public enum DataState {
	/// The user agent is attempting to establish the underlying data transport.
	/// This is the initial state of an RTCDataChannel object, whether created
	/// with createDataChannel, or dispatched as a part of an RTCDataChannelEvent.
	case connecting

	/// The underlying data transport is established and communication is possible.
	case open

	/// The procedure to close down the underlying data transport has started.
	case closing

	/// The underlying data transport has been closed or could not be established.
	case closed
}
