[![CocoaPods](https://img.shields.io/cocoapods/v/Mediasoup-Client-Swift?style=flat)](https://img.shields.io/cocoapods/v/Mediasoup-Client-Swift)
[![CocoaPods](https://img.shields.io/cocoapods/l/Mediasoup-Client-Swift?style=flat)](https://img.shields.io/cocoapods/l/Mediasoup-Client-Swift)

# Mediasoup-Client-Swift

Swift wrapper for libmediasoupclient with iOS support

## Key features

1. **First-class Swift support**

   * No crashes caused by unhandled C++ exceptions. Each throwing C++ function is properly wrapped and throws a catchable `Swift.Error`.  

   * No implicitly-unwrapped optionals in public interface. All unsafe operations are hidden inside wrapper.

   * No Objective-C entities in public interface. All you need is wrapped into normal Swift entities and protocols. There is no need to inherit `NSObject` in your delegates, no obscure `NSErrors`, almost no obscure `NSString` and `NSInteger` based "enums".

2. **Ease of integration**

   If you don't need to customize Mediasoup-Client-Swift itself or its dependencies, just use Swift Package Manager or CocoaPods:

   ```Ruby
   pod 'Mediasoup-Client-Swift', '0.8.1'
   ```

3. **Ease of building from scratch**

   All dependencies (WebRTC, libmediasoupclient, libsdptransform) are prebuilt and added to the repo as binary .xcframework's to reduce application build time. Fetching and building them from scratch takes couple of hours. If your security policy doesn't allow to import binary dependencies, or you just wand to go deeper, you can build everything on your machine.

   Dependencies are resolved with one command: `.\build.sh`. WebRTC sources are fetched from official repo and than patched locally to make it usable on iOS platform and also to expose some missing things. If you want to switch to another WebRTC version, configure WebRTC build flags, or make other customizations, dive into `build.sh`. We use XCFrameworks to cover both devices and simulators, including simulators on Apple Silicon macs, which is not possible with older `.framework` format.

4. **Out-of-the box codecs support**

   * Hardware-accelerated H264 on supported iOS devices.

   * VP8 software codec.

   * Other codecs can be added easily (look into `DeviceWrapper` initialization).

5. **TURN servers support**

   We've patched *libmediasoupclient* to support modern format of `RTCIceServer`s description when passed to `UpdateIceServers` method.

6. **No memory leaks**

   Ok, no *known* memory leaks ;)

## Usage

   Given that you have a Mediasoup server and signaling is already set up in your app, here is an example of a minimalistic client implementation:

   ```Swift
   import UIKit
   import Mediasoup
   import AVFoundation
   import WebRTC
   
   final class MediasoupClient {
       private let signaling: Signaling
       private let pcFactory = RTCPeerConnectionFactory()
       private var mediaStream: RTCMediaStream?
       private var audioTrack: RTCAudioTrack?
       private var device: Device?
       private var sendTransport: SendTransport?
       private var producer: Producer?
   
       init(signaling: Signaling) {
           self.signaling = signaling
       }
   
       func setupDevices() {
           guard AVCaptureDevice.authorizationStatus(for: .audio) == .authorized else {
               AVCaptureDevice.requestAccess(for: .audio) { _ in
               }
               return
           }
   
           mediaStream = pcFactory.mediaStream(withStreamId: Constants.mediaStreamId)
           let audioTrack = pcFactory.audioTrack(withTrackId: Constants.audioTrackId)
           mediaStream?.addAudioTrack(audioTrack)
           self.audioTrack = audioTrack
   
           let device = Device()
           self.device = device
           do {
               try device.load(with: signaling.rtpCapabilities)
               let sendTransport = try device.createSendTransport(
                   id: signaling.sendTransportId,
                   iceParameters: signaling.sendTransportICEParameters,
                   iceCandidates: signaling.sendTransportICECandidates,
                   dtlsParameters: signaling.sendTransportDTLSParameters,
                   sctpParameters: nil,
                   appData: nil
               )
               sendTransport.delegate = self
               self.sendTransport = sendTransport
   
               let producer = try sendTransport.createProducer(
                   for: audioTrack,
                   encodings: nil,
                   codecOptions: nil,
                   appData: nil
               )
               self.producer = producer
               producer.delegate = self
               producer.resume()
           } catch let error as MediasoupError {
               // Handle errors.
           } catch {
               // Handle errors.
           }
       }
   }
   
   extension MediasoupClient: SendTransportDelegate {
       func onProduce(transport: Transport, kind: MediaKind, rtpParameters: String, appData: String, callback: @escaping (String?) -> Void) {
           // Handle state changes.
       }
   
       func onProduceData(transport: Transport, sctpParameters: String, label: String, protocol dataProtocol: String, appData: String, callback: @escaping (String?) -> Void) {
           // Handle state changes.
       }
   
       func onConnect(transport: Transport, dtlsParameters: String) {
           // Handle state changes.
       }
   
       func onConnectionStateChange(transport: Transport, connectionState: TransportConnectionState) {
           
           // Handle state changes.
       }
   }
   
   extension MediasoupClient: ProducerDelegate {
       func onTransportClose(in producer: Producer) {
           // Handle state changes.
       }
   }
   ```

## Dependencies

Mediasoup-Client-Swift has almost no logic, it's only a convenient wrapper for other nice libraries. 

* [WebRTC (version m120 with patches applied locally)](https://groups.google.com/g/discuss-webrtc/c/ws0_MYHIBOw)

* [libmediasoupclient (version 3.4.1 patched fork)](https://github.com/VLprojects/libmediasoupclient) 

## Roadmap

- [x] Upgrade WebRTC and libmediasoupclient to latest versions

- [x] Add data channel support (consuming)

- [x] Support integration via SPM

- [ ] Add documentation for Mediasoup-Client-Swift public interface

- [ ] Investigate and reduce the amount of WebRTC patches

- [ ] Make the dependencies build script more flexible: add parametrization for included codecs and other WebRTC modules, build architectures and so on

- [ ] Add data channel support (producing)

- [ ] Implement example app compatible with https://v3demo.mediasoup.org
