import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mediport/core/component/tabbar/bottom_tab_bar.dart';
import 'package:mediport/core/enum/app_router.dart';
import 'package:mediport/core/provider/app_router_observer.dart';
import 'package:mediport/core/view/web_view/term_web_view.dart';
import 'package:mediport/presentation/auth/view/auth_screen.dart';
import 'package:mediport/presentation/auth/view/find/find_id_screen.dart';
import 'package:mediport/presentation/auth/view/find/find_password_screen.dart';
import 'package:mediport/presentation/home/view/home_screen.dart';
import 'package:mediport/presentation/my/my_screen.dart';
import 'package:mediport/presentation/splash_screen.dart';

import '../../presentation/auth/view/find/auth_update_password_screen.dart';
import '../../presentation/auth/view/join/join_screen.dart';
import '../../presentation/home/view/component_view_screen.dart';
import 'auth_provider.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// Default Transition 이 필요한 경우 각 GoRoute 메소드 내의 pageBuilder 프로퍼티 내에서 해당 함수를 호출하여 사용한다.
///
/// ex. pageBuilder: (context, state) => buildPageWithDefaultTransition(context: context, state: state, child: const Example2Screen())
CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
  );
}

/// 라우트 집합
final routerConfigProvider = Provider<GoRouter>(
  (ref) {
    final List<RouteBase> routes = [
      // 스플래시 페이지
      GoRoute(
        path: AppRouter.splash.path,
        name: AppRouter.splash.name,
        builder: (context, state) => const SplashScreen(),
      ),

      // 약관 웹뷰
      GoRoute(
        path: AppRouter.webviewTerm.path,
        name: AppRouter.webviewTerm.name,
        builder: (context, state) {
          final termTitle = state.uri.queryParameters['termTitle']!;
          final termUrl = state.uri.queryParameters['termUrl']!;
          return TermWebView(termTitle: termTitle, termUrl: termUrl);
        },
      ),

      /// Auth
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: AppRouter.auth.path,
        name: AppRouter.auth.name,
        builder: (context, state) => const AuthScreen(),
        routes: <RouteBase>[
          // 회원 가입 페이지
          GoRoute(
            // routes 내부에 선언하여 GoRoute 가 상위 경로를 생략하므로, path 를 name 으로 정의.
            // (enum AppRouter 정의한 이름과 path 를 같이 하였음)
            parentNavigatorKey: rootNavigatorKey,
            path: AppRouter.join.name,
            name: AppRouter.join.name,
            builder: (context, state) {
              final String? loginId = state.uri.queryParameters['loginId']; // SNS 회원가입 시, SNS Identifier
              final String? snsProvider = state.uri.queryParameters['snsProvider']; // ex. kakao, naver, apple ...
              return JoinScreen(
                loginId: loginId,
                snsProvider: snsProvider,
              );
            },
          ),

          // 아이디 찾기 페이지
          GoRoute(
            parentNavigatorKey: rootNavigatorKey,
            path: AppRouter.findId.name,
            name: AppRouter.findId.name,
            builder: (context, state) => const FindIdScreen(),
          ),

          // 비밀번호 찾기 페이지
          GoRoute(
            parentNavigatorKey: rootNavigatorKey,
            path: AppRouter.findPassword.name,
            name: AppRouter.findPassword.name,
            builder: (context, state) => const FindPasswordScreen(),
          ),

          // // 비밀번호 변경 페이지
          GoRoute(
            parentNavigatorKey: rootNavigatorKey,
            path: AppRouter.findPasswordUpdate.name,
            name: AppRouter.findPasswordUpdate.name,
            builder: (context, state) {
              return const AuthUpdatePasswordScreen();
            },
          ),
        ],
      ),

      /* 바텀 탭바가 표시할 각 루트 스크린 */
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => BottomTabBar(state: state, child: child),
        routes: [
          GoRoute(
            path: AppRouter.home.path,
            name: AppRouter.home.name,
            pageBuilder: (context, state) => buildPageWithDefaultTransition(context: context, state: state, child: const HomeScreen()),
          ),
          /* 마이 탭 */
          GoRoute(
            path: AppRouter.my.path,
            name: AppRouter.my.name,
            pageBuilder: (context, state) => buildPageWithDefaultTransition(context: context, state: state, child: const MyScreen()),
            // routes: [
            //   GoRoute(
            //     parentNavigatorKey: rootNavigatorKey,
            //     path: AppRouter.exampleSub.subPath,
            //     name: AppRouter.exampleSub.name,
            //     builder: (context, state) => const ExampleSubScreen(),
            //   ),
            // ]
          ),
        ],
      ),
    ];

    final provider = ref.read(authProvider);

    // authProvider 를 구독하고 있다가, userInfo 의 상태가 변경되면 redirectLoic 을 호출시킨다.
    return GoRouter(
      navigatorKey: rootNavigatorKey,
      routes: routes,
      initialLocation: AppRouter.splash.path,
      observers: <NavigatorObserver>[AppRouterObserver()],
      refreshListenable: provider,
      redirect: provider.redirectLogic,
    );
  },
);
