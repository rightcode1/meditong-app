import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  /// 전달받은 [Permission] 타입에 대하여 허용 여부를 체크한다.
  ///
  /// 만일, 체크되어 있지 않을 경우 요청하며, OS 별로 활용되는 권한이 상이하므로 하기 조건문에서 적절히 처리하여 사용하도록 한다.
  /// 관련 Permission 이 담긴 링크는 하기와 같다.
  ///
  /// Permission Docs: https://pub.dev/documentation/permission_handler/latest/
  /// Permission Handler 권한 리스트: https://pub.dev/documentation/permission_handler_platform_interface/latest/permission_handler_platform_interface/Permission-class.html#constants
  /// AOS 권한 리스트: https://github.com/Baseflow/flutter-permission-handler/blob/main/permission_handler/example/android/app/src/main/AndroidManifest.xml
  /// IOS 권한 리스트: https://github.com/Baseflow/flutter-permission-handler/blob/main/permission_handler/example/ios/Runner/Info.plist
  static Future<void> checkAndRequestPermission(BuildContext context, Permission permission) async {
    // 각 OS 별로 특정 기능을 사용하기 위한 Permission 이 다르므로 각 OS 에서 필요 없는 권한은 건너뛴다.
    if (Platform.isIOS) {
      if (permission == Permission.activityRecognition || permission == Permission.storage || permission == Permission.systemAlertWindow) return;
      debugPrint('IOS: ${permission.toString()} 에 대한 권한 설정을 수행합니다.');
    } else {
      if (permission == Permission.photos || permission == Permission.sensors) return;
      debugPrint('AOS: ${permission.toString()} 에 대한 권한 설정을 수행합니다.');
    }

    // 이미 권한이 부여된 경우에는 바로 return
    if (await permission.isGranted) {
      debugPrint('${permission.toString()} 에 대한 권한이 이미 허용되었습니다.');
      return;
    }

    final PermissionStatus status = await permission.request();

    if (status == PermissionStatus.granted) {
      // 권한이 부여된 경우
      debugPrint('${permission.toString()} 권한이 부여되었습니다.');
    } else {
      // 권한이 거절된 경우
      debugPrint('${permission.toString()} 권한이 거절되었습니다.');
      debugPrint('isDenied: ${await permission.isDenied}');
      debugPrint('isPermanentlyDenied: ${await permission.isPermanentlyDenied}');
      // openAppSettings();
    }
  }
}