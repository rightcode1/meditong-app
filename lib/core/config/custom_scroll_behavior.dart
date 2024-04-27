import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// 기본 스크롤 시 렌더링할 동작을 Overriding 한다. (AOS 환경에서 Glow 제거 및 웹앱 환경 내에서 ListView, PageView 등의 드래그 시, 마우스 이벤트 감지를 위한 목적)
class CustomScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown,
      };
}
