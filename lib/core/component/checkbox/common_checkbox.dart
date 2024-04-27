import 'package:flutter/material.dart';

class CommonCheckbox extends StatelessWidget {
  final Widget selectedIcon;
  final Widget unselectedIcon;
  final bool selected;

  const CommonCheckbox({
    required this.selectedIcon,
    required this.unselectedIcon,
    required this.selected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 250),
      firstChild: selectedIcon,
      secondChild: unselectedIcon,
      crossFadeState: selected ? CrossFadeState.showFirst : CrossFadeState.showSecond,
    );
  }
}
