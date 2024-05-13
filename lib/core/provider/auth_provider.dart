import 'package:mediport/core/constant/prefs_keys.dart';
import 'package:mediport/core/enum/app_router.dart';
import 'package:mediport/core/enum/permission_type.dart';
import 'package:mediport/core/provider/shared_prefs_provider.dart';
import 'package:mediport/core/util/permission_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/model/user/res/user_res.dart';
import '../../service/user/provider/user_providers.dart';

/// Authorization 을 처리하기 위한 최상위 역할을 하는 Provider
final authProvider = ChangeNotifierProvider<AuthChangeNotifier>((ref) => AuthChangeNotifier(ref: ref));

class AuthChangeNotifier extends ChangeNotifier {
  final Ref ref;

  /// [routerProvider] 는 [authProvider] 를 listening 하고 있다가, notify 가 일어날 경우,
  /// [redirectLogic] 을 동작시킨다.
  AuthChangeNotifier({required this.ref}) {
    // 유저의 상태가 변경될 경우(null 또는 다른 상태로 변경될 경우), notify 한다.
    ref.listen<UserResBase?>(userInfoProvider, (previous, next) {
      if (previous != next) {
        notifyListeners();
      }
    });
  }

  /// 권한 체크
  Future<void> _doPermissionCheck(BuildContext context) async {
    await Future.forEach(PermissionType.values, (eachPermission) async {
      await PermissionUtils.checkAndRequestPermission(context, eachPermission.type);
    });

    await Future.delayed(const Duration(milliseconds: 1000));
  }

  /// 리다이렉트 로직
  Future<String?> redirectLogic(BuildContext context, GoRouterState state) async {
    final UserResBase? user = ref.read(userInfoProvider);

    // 로그인 및 회원가입에 대하여 리다이렉트를 방지할 라우팅 플래그 변수 정의
    final String currentLocation = state.uri.path;

    debugPrint(currentLocation);
    // Splash Router 인지 확인.
    final isSplash = currentLocation == AppRouter.splash.path;
    // Auth Router 인지 확인.
    final isAuth = currentLocation.startsWith(AppRouter.auth.path);

    /// 로그인 필요 라우트 리스트 (로그인 후, 원래 이동하려고 했던 페이지로 이동한다.)
    final List<String> loginNeededRouteList = [
      AppRouter.alert.path,
      AppRouter.inquiry.path,
    ];

    // User 정보가 없는 (UserResLoading, UserResError, Null) 상태
    if (user is! UserRes) {
      // User 정보값을 받아오는 중인 상태
      if (user is UserResLoading) return null;

      // splash 화면일 경우 delay 후 Auth Router 로 이동.
      if (isSplash) {
        await _doPermissionCheck(context);
      }

      if (loginNeededRouteList.contains(currentLocation)) {
        final prefs = await ref.read(sharedPrefsProvider.future);
        prefs.setString(PrefsKeys.expectedRouteAfterLogin, currentLocation);
        debugPrint('===> 로그인 후, $currentLocation 로 이동합니다.');
        return AppRouter.auth.path;
      }

      return isSplash ? AppRouter.home.path : null;
    }

    if (isSplash) {
      await _doPermissionCheck(context);
    }

    // User 정보를 받아온 상태, home 으로 redirect (API 통신 시간 동안 splash 화면)
    return isAuth || isSplash ? AppRouter.home.path : null;
  }
}
