import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediport/core/constant/app_color.dart';

class CommonChip extends StatelessWidget {
  /// 기본적으로 사용되는 칩을 렌더링한다.
  ///
  /// 텍스트인 [text] 를 필수적으로 전달받는다.
  /// 배경 색상을 의미하는 [backgroundColor] 를 전달받을 수 있다. 정의되지 않을 경우, 기본 색상으로 렌더링된다.
  /// 텍스트 색상을 의미하는 [textColor] 를 전달받을 수 있다. 정의되지 않을 경우, 기본 색상으로 렌더링한다.
  ///
  /// 칩의 형상을 정의할 수 있는 인자를 전달받을 수 있다. 정의되지 않을 경우, 기본 값을 사용한다.
  /// [useBorder] 를 통해 칩의 Border 를 정의할 수 있다. default 는 [false] 이다.
  /// [padding] 을 전달받아 칩의 패딩을 정의할 수 있다.
  /// [fontSize] 를 전달받아 칩의 텍스트 크기를 정의할 수 있다.
  /// [fontWeight] 를 전달받아 칩의 텍스트 굵기를 정의할 수 있다.
  /// [borderRadius] 를 전달받아 칩의 BorderRadius 를 정의할 수 있다.
  const CommonChip({
    this.textWidget,
    this.text,
    this.backgroundColor,
    this.textColor,
    this.useBorder = false,
    this.padding,
    this.fontSize,
    this.fontWeight,
    this.borderRadius,
    super.key,
  });

  final Widget? textWidget;
  final String? text;
  final Color? backgroundColor;
  final Color? textColor;
  final bool useBorder;
  final EdgeInsets? padding;
  final double? fontSize;
  final FontWeight? fontWeight;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    if (text == null && textWidget == null) throw Exception('text 또는 textWidget 둘 중에 한 개는 반드시 명세되어야합니다.');
    if (text != null && textWidget != null) throw Exception('text 및 textWidget 은 둘 중 한 개만 사용할 수 있습니다.');

    return Container(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 14.0.w, vertical: 10.0.h),
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color.fromRGBO(250, 250, 250, 1.0),
        borderRadius: borderRadius ?? BorderRadius.circular(5.0.r),
        border: !useBorder ? null : Border.all(color: AppColor.grey500, width: 1.0.w),
      ),
      child: textWidget ?? Text(
        text!,
        style: TextStyle(
          fontSize: fontSize ?? 14.0.sp,
          fontWeight: fontWeight ?? FontWeight.w600,
          color: textColor ?? AppColor.darkGrey500,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
