// import 'package:flutter/foundation.dart';

// import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc_impl;
// import 'package:matrix/matrix.dart';
// // ignore: depend_on_referenced_packages
// import 'package:webrtc_interface/webrtc_interface.dart' hide Navigator;

// class VoipDelegate extends WebRTCDelegate {
//   @override
//   MediaDevices get mediaDevices => webrtc_impl.navigator.mediaDevices;

//   @override
//   Future<webrtc_impl.RTCPeerConnection> createPeerConnection(
//           Map<String, dynamic> configuration,
//           [Map<String, dynamic> constraints = const {}]) =>
//       webrtc_impl.createPeerConnection(configuration, constraints);

//   @override
//   VideoRenderer createRenderer() {
//     return webrtc_impl.RTCVideoRenderer();
//   }

//   @override
//   Future<void> playRingtone() {
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> stopRingtone() {
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> handleNewCall(CallSession session) {
//     // handle new call incoming or outgoing
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> handleCallEnded(CallSession session) {
//     throw UnimplementedError();
//   }

//   @override
//   bool get canHandleNewCall => throw UnimplementedError();

//   @override
//   Future<void> handleGroupCallEnded(GroupCall groupCall) {
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> handleMissedCall(CallSession session) {
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> handleNewGroupCall(GroupCall groupCall) {
//     throw UnimplementedError();
//   }

//   @override
//   bool get isWeb => kIsWeb;
// }
