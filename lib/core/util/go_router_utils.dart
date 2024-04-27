import 'package:mediport/core/constant/prefs_keys.dart';
import 'package:mediport/core/provider/extra_provider.dart';
import 'package:mediport/core/provider/shared_prefs_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mediport/core/enum/app_router.dart';

class GoRouterUtils {
  /// [tabIndex] 를 전달받아 루트 탭의 특정 탭 인덱스(tabIndex)로 이동한다.
  ///
  /// 이때, 현재 스택에 쌓인 모든 스크린을 pop 한 후, Root path 가 감지될 경우, pushReplacementNamed 를 통해 루트 탭 스크린을
  /// 원하는 탭 인덱스에 해당하는 루트 탭 스크린으로 변경한다.
  static void moveToRootTabScreenWithSpecifiedIndex(BuildContext context, int tabIndex) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    GoRouter.of(context).pushReplacementNamed(AppRouter.home.name, queryParameters: {
      'initialTabIndex': tabIndex.toString(),
    });
  }

  /// 로그인 후, 이동할 페이지를 Prefs 에 기록한다.
  static Future<void> recordExpectedRoute(BuildContext context, WidgetRef ref,
      {required String expectedRoute, Map<String, dynamic>? queryParameters, Object? extra}) async {
    final prefs = await ref.read(sharedPrefsProvider.future);
    expectedRoute = queryParameters != null ? '$expectedRoute?${Uri(queryParameters: queryParameters).query}' : expectedRoute;
    prefs.setString(PrefsKeys.expectedRouteAfterLogin, expectedRoute);
    ref.read(extraProvider.notifier).state = extra;
    debugPrint('===> 로그인 후, $expectedRoute 로 이동합니다.');
  }

  /// 로그인 후, 이동할 페이지를 Prefs 에 기록하고, 로그인 페이지로 즉시 이동시킨다.
  static Future<void> recordExpectedRouteAndGoToAuth(BuildContext context, WidgetRef ref,
      {required String expectedRoute, Map<String, dynamic>? queryParameters, Object? extra}) async {
    final prefs = await ref.read(sharedPrefsProvider.future);
    expectedRoute = queryParameters != null ? '$expectedRoute?${Uri(queryParameters: queryParameters).query}' : expectedRoute;
    prefs.setString(PrefsKeys.expectedRouteAfterLogin, expectedRoute);
    ref.read(extraProvider.notifier).state = extra;
    debugPrint('===> 로그인 후, $expectedRoute 로 이동합니다.');

    if (!context.mounted) return;
    context.pushNamed(AppRouter.auth.name);
  }

  /// expectedRouteAfterLogin 를 제거한다.
  static Future<void> removeExpectedRoute(WidgetRef ref) async {
    final prefs = await ref.read(sharedPrefsProvider.future);
    await prefs.remove(PrefsKeys.expectedRouteAfterLogin);
    ref.invalidate(extraProvider);
    debugPrint('===> 로그인 취소 :: expectedRoute 가 제거되었습니다.');
  }

  /// 로그인 후, 기존에 이동하려고 했던 페이지로 라우팅한다.
  static Future<void> moveToExpectedRouteAfterSingingIn(BuildContext context, WidgetRef ref) async {
    // 쿠키에 원래 이동하려고 했던 목적지인 expectedRoute 에 대한 정보가 존재할 경우, 해당 경로로 라우팅한다.
    final prefs = await ref.read(sharedPrefsProvider.future);
    String? expectedRoute = prefs.getString(PrefsKeys.expectedRouteAfterLogin);
    final extra = ref.read(extraProvider); // 페이지 이동 시, 추가적으로 해당 페이지로 들고 갈 extra

    if (expectedRoute != null) {
      final queryParameters = Uri.parse(expectedRoute).queryParameters;

      /// expectedRoute 에서 쿼리 스트링을 제거한다.
      final queryIndexOf = expectedRoute.indexOf('?');
      expectedRoute = queryIndexOf != -1 ? expectedRoute.substring(0, queryIndexOf) : expectedRoute;

      debugPrint('===> 로그인 후 기존 라우트로 이동합니다. expectedRoute=$expectedRoute');
      await prefs.remove(PrefsKeys.expectedRouteAfterLogin);
      ref.invalidate(extraProvider);
      debugPrint('===> expectedRoute 가 제거되었습니다.');

      if (!context.mounted) return;

      if (expectedRoute.contains('/')) {
        return GoRouter.of(context).go(expectedRoute, extra: extra);
      } else {
        return GoRouter.of(context).goNamed(expectedRoute, queryParameters: queryParameters, extra: extra);
      }
    } else {
      if (!context.mounted) return;
      // 기록된 이동 경로가 없을 경우, 홈 화면으로 이동한다.
      GoRouter.of(context).goNamed(AppRouter.home.name);
    }
  }
}