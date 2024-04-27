import 'package:flutter/material.dart';

class BrokenImplicitScrollPhysics extends ScrollPhysics {

  /// [ScrollPhysics] 를 상속받아 Implicit Scroll 을 막는 [ScrollPhysics] 를 구현한 클래스
  const BrokenImplicitScrollPhysics({ ScrollPhysics? parent }) : super(parent: parent);

  @override
  BrokenImplicitScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return BrokenImplicitScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  bool get allowImplicitScrolling => false;
}