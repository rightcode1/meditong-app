import 'dart:io';

import 'package:mediport/core/enum/app_router.dart';
import 'package:mediport/core/util/toast_utils.dart';
import 'package:mediport/core/variable/global_var.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CoreUtils {
  /// AOS 환경에서 뒤로가기 버튼 두 번 클릭 시 앱을 종료하기 위한 헬퍼 메소드
  ///
  /// PopScope 내 적용
  static Future<void> appExitWithBackButton(BuildContext context) async {
    if (Platform.isAndroid) {
      appExitCount++;

      if (appExitCount == 1) {
        ToastUtils.showToast(context, toastText: '뒤로가기를 한 번 더 누르면 앱이 종료됩니다.');
      }

      if (appExitCount == 2) {
        SystemNavigator.pop();
      }

      Future.delayed(const Duration(seconds: 2)).then((_) => appExitCount = 0);
    }

    return;
  }

  /// 현재 기기가 폴드인지 확인하는 메소드
  ///
  /// 비율 확인 후, 0.8 ~ 1.2 사이면 폴드로 판단한다.
  static bool checkIfFoldDevice(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width.toDouble();
    final double height = screenSize.height.toDouble();
    double ratio = width / height;

    /// 폴드 0.88
    /// 아이패드 mini 0.65
    /// 아이패드 pro 12.9 0.75
    /// SE3 0.56
    /// 기존 휴대폰 0.5~
    /// [true] : thumbnailOne, [false] : thumbnail
    bool isFold = ratio >= 0.8 && ratio <= 1.2;

    return isFold;
  }

  /// 현재 기기가 태블릿인지 확인하는 메소드
  static bool checkIfMobile(BuildContext context) {
    return MediaQuery.sizeOf(context).shortestSide < 600;
  }

  /// FCM/딥링크 등 데이터를 전달받아 적절한 화면으로 분기처리한다.
  static void deepLinkMoveToSpecificScreen(BuildContext context, Map<String, dynamic> data, { WidgetRef? widgetRef, Ref? ref }) async {
    if (ref == null && widgetRef == null) {
      debugPrint('===> No ref or widgetRef. It will do nothing.');
      return;
    }
    if (data.isNotEmpty) {
      debugPrint('===> FCM 푸시로부터 전달받은 데이터=$data');
      final action = data['action'] as String;

      /// Action is ... 일 경우, ...페이지로 이동한다.
      if (action == '...') {
        // context.pushNamed(AppRouter.referralCustomer.name);
      } else if (action == '......') {
        // context.pushNamed(AppRouter.saving.name);
      } else {
        // widgetRef == null ? await ref!.read(userInfoProvider.notifier).getInfo() : await widgetRef.read(userInfoProvider.notifier).getInfo();
        // if (!context.mounted) return;
        //
        // final user = widgetRef == null ? ref!.read(userInfoProvider) as UserRes : widgetRef.read(userInfoProvider) as UserRes;
        //
        // if (user.role == '전문업체' && user.professionalUser!.active) {
        //   final isProfileActive = user.professionalUser!.active;
        //   debugPrint('===> 전문업체 프로필 활성화 여부=$isProfileActive');
        //
        //   /// 만일, isProfileActive 가 false 일 경우, 안내 팝업을 띄운다.
        //   if (!isProfileActive) {
        //     BottomSheetUtils.showExpertCannotAccess(context: context);
        //     return;
        //   }
        // }
        //
        // final roomId = int.parse(data['id']);
        // final opponentName = data['name'];
        //
        // widgetRef == null ? ref!.read(sharedPrefsProvider.future).then((prefs) {
        //   prefs.setInt(PrefsKeys.currentRoomId, roomId);
        // }) : widgetRef.read(sharedPrefsProvider.future).then((prefs) {
        //   prefs.setInt(PrefsKeys.currentRoomId, roomId);
        // });
        // widgetRef == null ? ref!.read(socketManagerProvider.notifier).joinRoom(roomId: roomId) : widgetRef.read(socketManagerProvider.notifier).joinRoom(roomId: roomId);
        // context.pushNamed(AppRouter.messageChat.name, queryParameters: {
        //   'roomId': roomId.toString(),
        //   'opponentName': opponentName ?? '-',
        // });
      }
    }
  }
}