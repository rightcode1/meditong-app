import 'package:mediport/core/enum/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomTabBar extends StatefulWidget {
  const BottomTabBar({super.key, required this.child});

  final Widget child;

  @override
  State<BottomTabBar> createState() => _BottomTabBarState();
}

class _BottomTabBarState extends State<BottomTabBar> {
  int _currentIndex = 0;

  void _changeTab(int index) {
    switch (index) {
      case 0:
        context.goNamed(AppRouter.home.name);
        break;
      case 1:
        context.goNamed(AppRouter.example2.name);
        break;
      case 2:
        context.goNamed(AppRouter.example2.name);
        break;
      case 3:
        context.goNamed(AppRouter.example2.name);
        break;
      case 4:
        context.goNamed(AppRouter.my.name);
        break;
      default:
        context.goNamed(AppRouter.home.name);
        break;
    }
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: _changeTab,
        selectedIndex: _currentIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: '마이',
          )
        ],
      ),
    );
  }
}
