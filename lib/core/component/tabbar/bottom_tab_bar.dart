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
    [AppRouter.home.path, '홈', const Icon(Icons.home)],
    [AppRouter.home.path, '홈', const Icon(Icons.home)],
  ];

  /// 현재 탭 인덱스
  int _currentIndex = 0;

  void _changeTab(int index) {
    context.go(_tabRoutes[index][0] as String);
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
          onDestinationSelected: _changeTab,
          selectedIndex: _currentIndex,
          destinations: _tabRoutes.map((e) => NavigationDestination(label: e[1], icon: e[2])).toList(),
        ));
  }
}
