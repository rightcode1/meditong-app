import 'package:flutter/cupertino.dart';

/// App Log 를 위한 Observer
/// TODO Firebase.analytics 등의 로그 기록 API 사용
/// https://github.com/flutter/flutter/issues/112196 Observer 이슈
class AppRouterObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    print('AppRoute Push : ${previousRoute?.settings.name} -> ${route.settings.name}');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    print('AppRoute Replace : ${oldRoute?.settings.name} -> ${newRoute?.settings.name}');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    print('AppRoute Pop : ${previousRoute?.settings.name} <- ${route.settings.name}');
  }

  // @override
  // void didRemove(Route route, Route? previousRoute) {
  //   print('AppRoute Remove : ${route.settings.name}');
  // }
}
