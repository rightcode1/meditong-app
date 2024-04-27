import 'dart:io';

import 'package:mediport/core/config/http_override.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // HTTP Request per host 5 로 지정
  HttpOverrides.global = HttpOverride();

  final container = ProviderContainer();

  // TODO: FCM 사용 시 주석 해제하여 사용
  // FireBase 초기화
  // final initialLink = await container.read(firebaseUtilsProvider.notifier).initFirebase();
  // await container.read(firebaseUtilsProvider.notifier).doInitFcm();
  //
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    /// RivderPod 스코프 활성화
    UncontrolledProviderScope(
      container: container,
      child: const Mediport(),
    ),
  );
}

// TODO: FCM 사용 시 주석 해제하여 사용
/* App 이 Terminated 되어있는 환경에서 푸시 알림 클릭 시 Background 에서 해당 푸시를 캐치하기 위한 리스너 (Worker) */
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   debugPrint('===> FCM 이 Terminated 환경에서 동작하였습니다.');
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//
//   debugPrint('===> hihihihi=${message.data.toString()}');
// }
