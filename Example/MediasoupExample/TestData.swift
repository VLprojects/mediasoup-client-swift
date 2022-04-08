import Foundation


enum TestData {
	enum MediaStream { }
	enum Device { }
	enum SendTransport { }
}

extension TestData.MediaStream {
	static let mediaStreamId = "ARDAMS"
	static let audioTrackId = "ARDAMSa0"
}

extension TestData.Device {
	static let rtpCapabilities = """
	{ \"headerExtensions\" : [ { \"preferredEncrypt\" : false, \"uri\" : \"urn:ietf:params:rtp-hdrext:sdes:mid\", \"preferredId\" : 1, \"kind\" : \"audio\", \"direction\" : \"sendrecv\" }, { \"preferredEncrypt\" : false, \"uri\" : \"urn:ietf:params:rtp-hdrext:sdes:mid\", \"preferredId\" : 1, \"kind\" : \"video\", \"direction\" : \"sendrecv\" }, { \"preferredEncrypt\" : false, \"uri\" : \"urn:ietf:params:rtp-hdrext:sdes:rtp-stream-id\", \"kind\" : \"video\", \"preferredId\" : 2, \"direction\" : \"recvonly\" }, { \"preferredEncrypt\" : false, \"uri\" : \"urn:ietf:params:rtp-hdrext:sdes:repaired-rtp-stream-id\", \"kind\" : \"video\", \"preferredId\" : 3, \"direction\" : \"recvonly\" }, { \"preferredEncrypt\" : false, \"uri\" : \"http:\\/\\/www.webrtc.org\\/experiments\\/rtp-hdrext\\/abs-send-time\", \"kind\" : \"audio\", \"preferredId\" : 4, \"direction\" : \"sendrecv\" }, { \"preferredId\" : 4, \"preferredEncrypt\" : false, \"uri\" : \"http:\\/\\/www.webrtc.org\\/experiments\\/rtp-hdrext\\/abs-send-time\", \"kind\" : \"video\", \"direction\" : \"sendrecv\" }, { \"preferredId\" : 5, \"preferredEncrypt\" : false, \"uri\" : \"http:\\/\\/www.ietf.org\\/id\\/draft-holmer-rmcat-transport-wide-cc-extensions-01\", \"kind\" : \"audio\", \"direction\" : \"recvonly\" }, { \"preferredId\" : 5, \"preferredEncrypt\" : false, \"uri\" : \"http:\\/\\/www.ietf.org\\/id\\/draft-holmer-rmcat-transport-wide-cc-extensions-01\", \"kind\" : \"video\", \"direction\" : \"sendrecv\" }, { \"preferredId\" : 6, \"preferredEncrypt\" : false, \"uri\" : \"http:\\/\\/tools.ietf.org\\/html\\/draft-ietf-avtext-framemarking-07\", \"kind\" : \"video\", \"direction\" : \"sendrecv\" }, { \"preferredEncrypt\" : false, \"uri\" : \"urn:ietf:params:rtp-hdrext:framemarking\", \"kind\" : \"video\", \"preferredId\" : 7, \"direction\" : \"sendrecv\" }, { \"preferredEncrypt\" : false, \"uri\" : \"urn:ietf:params:rtp-hdrext:ssrc-audio-level\", \"kind\" : \"audio\", \"preferredId\" : 10, \"direction\" : \"sendrecv\" }, { \"preferredEncrypt\" : false, \"uri\" : \"urn:3gpp:video-orientation\", \"kind\" : \"video\", \"preferredId\" : 11, \"direction\" : \"sendrecv\" }, { \"preferredId\" : 12, \"kind\" : \"video\", \"preferredEncrypt\" : false, \"direction\" : \"sendrecv\", \"uri\" : \"urn:ietf:params:rtp-hdrext:toffset\" } ], \"codecs\" : [ { \"channels\" : 2, \"clockRate\" : 48000, \"mimeType\" : \"audio\\/opus\", \"parameters\" : { }, \"kind\" : \"audio\", \"rtcpFeedback\" : [ { \"parameter\" : \"\", \"type\" : \"transport-cc\" } ], \"preferredPayloadType\" : 100 }, { \"parameters\" : { \"level-asymmetry-allowed\" : 1, \"profile-level-id\" : \"42e01f\", \"x-google-start-bitrate\" : 1000, \"packetization-mode\" : 1 }, \"clockRate\" : 90000, \"preferredPayloadType\" : 101, \"kind\" : \"video\", \"rtcpFeedback\" : [ { \"parameter\" : \"\", \"type\" : \"nack\" }, { \"parameter\" : \"pli\", \"type\" : \"nack\" }, { \"type\" : \"ccm\", \"parameter\" : \"fir\" }, { \"type\" : \"goog-remb\", \"parameter\" : \"\" }, { \"parameter\" : \"\", \"type\" : \"transport-cc\" } ], \"mimeType\" : \"video\\/H264\" }, { \"parameters\" : { \"apt\" : 101 }, \"preferredPayloadType\" : 102, \"kind\" : \"video\", \"clockRate\" : 90000, \"rtcpFeedback\" : [ ], \"mimeType\" : \"video\\/rtx\" }, { \"parameters\" : { \"x-google-start-bitrate\" : 1000 }, \"preferredPayloadType\" : 103, \"kind\" : \"video\", \"clockRate\" : 90000, \"rtcpFeedback\" : [ { \"parameter\" : \"\", \"type\" : \"nack\" }, { \"type\" : \"nack\", \"parameter\" : \"pli\" }, { \"type\" : \"ccm\", \"parameter\" : \"fir\" }, { \"parameter\" : \"\", \"type\" : \"goog-remb\" }, { \"type\" : \"transport-cc\", \"parameter\" : \"\" } ], \"mimeType\" : \"video\\/VP8\" }, { \"kind\" : \"video\", \"mimeType\" : \"video\\/rtx\", \"parameters\" : { \"apt\" : 103 }, \"preferredPayloadType\" : 104, \"clockRate\" : 90000, \"rtcpFeedback\" : [ ] } ]}
	"""
}

extension TestData.SendTransport {
	static let transportId = "6f73ad69-01fa-4485-9cc5-3cad2c755f28"

	static let iceParameters = """
	{
		\"iceLite\": true,
		\"password\": \"ba13o2setyjsjbjmc7eglzp7an49w8gj\",
		\"usernameFragment\": \"m94en1rdwtqb2yyh\"
	}
	"""

	static let iceCandidates = """
	[
		{
			\"ip\": \"142.93.99.70\",
			\"priority\": 1076558079,
			\"foundation\": \"udpcandidate\",
			\"protocol\": \"udp\",
			\"port\": 11886,
			\"type\": \"host\"
		}, {
			\"port\": 11222,
			\"priority\": 1076302079,
			\"ip\": \"142.93.99.70\",
			\"type\": \"host\",
			\"protocol\": \"tcp\",
			\"foundation\": \"tcpcandidate\",
			\"tcpType\": \"passive\"
		}, {
			\"port\": 11742,
			\"priority\": 1076532479,
			\"protocol\": \"udp\",
			\"type\": \"host\",
			\"foundation\": \"udpcandidate\",
			\"ip\": \"10.114.0.5\"
		}, {
			\"port\": 11253,
			\"priority\": 1076276479,
			\"ip\": \"10.114.0.5\",
			\"type\": \"host\",
			\"foundation\": \"tcpcandidate\",
			\"protocol\": \"tcp\",
			\"tcpType\": \"passive\"
		}
	]
	"""

	static let dtlsParameters = """
	{
		\"role\": \"auto\",
		\"fingerprints\": [
			{
				\"algorithm\": \"sha-1\",
				\"value\": \"55:E6:84:B6:F8:DC:AE:0A:70:9E:45:39:F6:6A:B7:A2:4F:E1:C4:97\"
			}, {
				\"algorithm\": \"sha-224\",
				\"value\": \"46:90:F2:94:E6:53:FF:AA:C2:C4:E8:FB:EC:E5:65:43:DB:2B:91:7B:18:BC:8D:E6:48:36:F1:4E\"
			}, {
				\"algorithm\": \"sha-256\",
				\"value\": \"AA:97:3F:46:49:11:27:C5:C8:72:4E:05:61:FC:C4:29:C5:22:1A:02:3E:96:33:8D:D0:FB:2D:8E:E7:4F:26:3C\"
			}, {
				\"algorithm\": \"sha-384\",
				\"value\": \"60:DC:00:BF:86:03:17:56:1A:15:D1:F3:FE:53:A7:4F:83:F0:24:A5:E4:12:61:D4:77:B4:37:60:1C:DC:DD:66:83:3D:21:E6:C2:32:CF:18:5D:14:F1:8F:C3:40:28:89\"
			}, {
				\"algorithm\": \"sha-512\",
				\"value\": \"1B:21:BA:F4:D0:04:87:9F:D4:8C:4C:AE:D7:38:14:04:2C:9F:5D:C0:CC:72:1A:D7:CD:E5:45:7B:8E:B5:09:3B:EB:3B:EB:11:39:07:42:36:0E:5D:AE:D2:D7:4F:68:FC:3F:9B:37:70:AD:95:70:D7:A7:0A:D2:91:DB:95:3F:D4\"
			}
		]
	}
	"""
}
