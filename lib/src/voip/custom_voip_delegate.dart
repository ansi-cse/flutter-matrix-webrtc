// import 'package:matrix/matrix.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_foreground_task/flutter_foreground_task.dart';
// import 'package:ott/src/utils/famedlysdk_store.dart';
// import 'package:ott/src/utils/platform_infos.dart';
// import 'package:ott/src/voip/call_keep_manager.dart';
// import 'package:ott/src/voip/voip_delegate.dart';

// abstract class VoipPluginCallbacks {
//   void addCallingOverlay(String callId, CallSession call);
//   void onDontHasCallingAccount();
// }

// class VoipPlugin extends VoipDelegate with WidgetsBindingObserver {
//   final Client client;
//   final Function(String callId, CallSession call) addCallingOverlay;
//   final Function() onDontHasCallingAccount;

//   VoipPlugin(
//       this.client, this.addCallingOverlay, this.onDontHasCallingAccount) {
//     voip = VoIP(client, this);
//     Connectivity()
//         .onConnectivityChanged
//         .listen(_handleNetworkChanged)
//         .onError((e) => _currentConnectivity = ConnectivityResult.none);
//     Connectivity()
//         .checkConnectivity()
//         .then((result) => _currentConnectivity = result)
//         .catchError((e) => _currentConnectivity = ConnectivityResult.none);
//     if (!kIsWeb) {
//       final wb = WidgetsBinding.instance;
//       wb.addObserver(this);
//       didChangeAppLifecycleState(wb.lifecycleState);
//     }
//   }
//   bool background = false;
//   bool speakerOn = false;
//   late VoIP voip;
//   ConnectivityResult? _currentConnectivity;
//   OverlayEntry? overlayEntry;

//   void _handleNetworkChanged(ConnectivityResult result) async {
//     /// Got a new connectivity status!
//     if (_currentConnectivity != result) {
//       voip.calls.forEach((_, sess) {
//         sess.restartIce();
//       });
//     }
//     _currentConnectivity = result;
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState? state) {
//     Logs().v('AppLifecycleState = $state');
//     background = (state == AppLifecycleState.detached ||
//         state == AppLifecycleState.paused);
//   }

//   @override
//   Future<void> handleNewCall(CallSession session) async {
//     if (PlatformInfos.isAndroid) {
//       // probably works on ios too
//       final hasCallingAccount = await CallKeepManager().hasPhoneAccountEnabled;
//       if (session.direction == CallDirection.kIncoming &&
//           hasCallingAccount &&
//           session.type == CallType.kVoice) {
//         ///Popup native telecom manager call UI for incoming call.
//         final callKeeper = CallKeeper(CallKeepManager(), session);
//         CallKeepManager().addCall(session.callId, callKeeper);
//         await CallKeepManager().showCallkitIncoming(session);
//         return;
//       } else {
//         try {
//           final wasForeground = await FlutterForegroundTask.isAppOnForeground;
//           await Store().setItem(
//             'wasForeground',
//             wasForeground == true ? 'true' : 'false',
//           );
//           FlutterForegroundTask.setOnLockScreenVisibility(true);
//           FlutterForegroundTask.wakeUpScreen();
//           FlutterForegroundTask.launchApp();
//         } catch (e) {
//           Logs().e('VOIP foreground failed $e');
//         }
//         // use fallback flutter call pages for outgoing and video calls.
//         addCallingOverlay(session.callId, session);
//         if (!hasCallingAccount) {
//           onDontHasCallingAccount();
//         }
//       }
//     } else {
//       addCallingOverlay(session.callId, session);
//     }
//   }

//   @override
//   Future<void> playRingtone() async {}

//   @override
//   Future<void> stopRingtone() async {}

//   @override
//   Future<void> handleCallEnded(CallSession session) async {
//     if (overlayEntry != null) {
//       overlayEntry!.remove();
//       overlayEntry = null;
//       if (PlatformInfos.isAndroid) {
//         FlutterForegroundTask.setOnLockScreenVisibility(false);
//         FlutterForegroundTask.stopService();
//         final wasForeground = await Store().getItem('wasForeground');
//         wasForeground == 'false' ? FlutterForegroundTask.minimizeApp() : null;
//       }
//     }
//   }

//   @override
//   bool get canHandleNewCall =>
//       voip.currentCID == null && voip.currentGroupCID == null;

//   @override
//   Future<void> handleGroupCallEnded(GroupCall groupCall) async {}

//   @override
//   Future<void> handleMissedCall(CallSession session) async {}

//   @override
//   Future<void> handleNewGroupCall(GroupCall groupCall) async {}
// }
