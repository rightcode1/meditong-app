import 'dart:io';

import 'package:flutter/material.dart';

@Deprecated('Flutter 내 WillPopScope 가 Deprecated 됨에 따른 처리')
class CustomWillPopScope extends StatefulWidget {
  final Widget child;
  final Future<bool> Function() onWillPop;

  const CustomWillPopScope({Key? key, required this.child, required this.onWillPop}) : super(key: key);

  @override
  _CustomWillPopScopeState createState() => _CustomWillPopScopeState();
}

class _CustomWillPopScopeState extends State<CustomWillPopScope> {
  bool startedFromLeftEdge = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;

        // if (startedFromLeftEdge) {
        //   if (this.context.canPop()) {
        //     context.pop();
        //   } else {
        //     context.goNamed(AppRouter.home.name);
        //   }
          // !this.context.canPop() ? this.context.goNamed(AppRouter.home.name) : this.context.pop();
        // }
      },
      child: Platform.isIOS
          ? GestureDetector(
        onHorizontalDragStart: (details) {
          // 시작점이 화면의 왼쪽 가장자리 근처인지 확인
          if (details.globalPosition.dx < 50) {
            startedFromLeftEdge = true;
          }
        },
        onHorizontalDragEnd: (details) {
          // 시작점이 화면의 왼쪽 가장자리 근처이고 오른쪽으로 드래그되었는지 확인
          if (startedFromLeftEdge && details.velocity.pixelsPerSecond.dx > 0) {
            // Code for iOS
            // widget.onWillPop();
            setState(() {});
          }

          startedFromLeftEdge = false; // 드래그가 끝나면 초기화
        },
        child: widget.child,
      )
          : widget.child,
    );

    // return WillPopScope(
    //   onWillPop: widget.onWillPop,
    //   child: Platform.isIOS
    //       ? GestureDetector(
    //           onHorizontalDragStart: (details) {
    //             // 시작점이 화면의 왼쪽 가장자리 근처인지 확인
    //             if (details.globalPosition.dx < 50) {
    //               startedFromLeftEdge = true;
    //             }
    //           },
    //           onHorizontalDragEnd: (details) {
    //             // 시작점이 화면의 왼쪽 가장자리 근처이고 오른쪽으로 드래그되었는지 확인
    //             if (startedFromLeftEdge && details.velocity.pixelsPerSecond.dx > 0) {
    //               // Code for iOS
    //               widget.onWillPop();
    //             }
    //             startedFromLeftEdge = false; // 드래그가 끝나면 초기화
    //           },
    //           child: widget.child,
    //         )
    //       : widget.child,
    // );
  }
}
