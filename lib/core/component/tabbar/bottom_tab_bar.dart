import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediport/core/enum/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomTabBar extends ConsumerStatefulWidget {
  const BottomTabBar({super.key, required this.state, required this.child});

  final GoRouterState state;
  final Widget child;

  @override
  ConsumerState<BottomTabBar> createState() => _BottomTabBarState();
}

class _BottomTabBarState extends ConsumerState<BottomTabBar> {
  /// 탭 별 라우트 목록
  final List<List<dynamic>> _tabRoutes = [
    [AppRouter.home.name, '홈', const Icon(Icons.home)],
    [AppRouter.contents.name, '경영', const Icon(Icons.home)],
    [AppRouter.home.name, '영상', const Icon(Icons.home)],
    [AppRouter.contents.name, '장비', const Icon(Icons.home)],
    [AppRouter.home.name, '메디通', const Icon(Icons.home)],
  ];

  /// 현재 탭 인덱스
  int _currentIndex = 0;

  /// 탭 변경 메소드
  ///
  /// 경영 또는 장비 탭일 경우, QueryParameter 에 별도의 diff 값을 넣어 처리한다. (due to 스크린 공용화)
  void _changeTab(int index) {
    context.goNamed(_tabRoutes[index][0] as String, queryParameters: index == 1 || index == 3 ? {'diff': index == 1 ? '경영' : '장비'} : {});
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 현재 탭 경로가 변경될 경우, _tabRoutes 내의 항목에 맞게 _currentIndex 를 변경한다.
    final currentLocation = widget.state.fullPath;
    if (currentLocation != null) {
      final currentTab = _tabRoutes.indexWhere((element) => element[0] == currentLocation);
      if (currentTab != -1) {
        _currentIndex = currentTab;
      }
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: widget.child,
        bottomNavigationBar: NavigationBar(
          indicatorColor: Colors.transparent,
          onDestinationSelected: _changeTab,
          selectedIndex: _currentIndex,
          destinations: _tabRoutes.map((e) => NavigationDestination(label: e[1], icon: e[2])).toList(),
        ));
  }
}
