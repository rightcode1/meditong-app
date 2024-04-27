import 'package:meditong/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 쉐도우가 적용된 형태의 컨테이너
///
/// [padding] 을 전달받아 컨테이너 내부 위젯의 패딩을 정의한다.
/// [widget] 을 전달받아 컨테이너 내부에 렌더링 할 위젯을 정의한다.
class DefaultShadowContainer extends StatelessWidget {
  final EdgeInsets padding;
  final Widget widget;
  final Color borderColor;

  const DefaultShadowContainer({
    required this.padding,
    required this.widget,
    this.borderColor = GREY_COLOR,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0.h),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: SHADOW_COLOR,
            blurRadius: 6.0.h,
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: Padding(
        padding: padding,
        child: widget,
      ),
    );
  }
}
