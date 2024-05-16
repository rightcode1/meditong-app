import 'package:mediport/core/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 가장 기본이 되는 버튼 컴포넌트, 형태에 맞게 재구성하여 사용한다.
class CommonButton extends StatelessWidget {
  /// 버튼 텍스트
  final String? text;

  /// 버튼 텍스트 위젯
  final Widget? textWidget;

  /// 버튼 클릭 시 콜백
  final VoidCallback onPressed;

  /// 버튼 활성화 여부
  final bool isActive;

  /// 버튼 색상
  final Color? backgroundColor;

  /// 폰트 사이즈
  final double? fontSize;

  /// 폰트 굵기
  final FontWeight? fontWeight;

  /// 텍스트 색상
  final Color? textColor;

  final double? elevation;

  final BorderRadius? borderRadius;

  final bool isLoading;

  final EdgeInsets? padding;

  final bool useBorder;

  final Color? foregroundColor;

  const CommonButton({
    this.text,
    this.textWidget,
    required this.onPressed,
    this.isActive = true,
    this.backgroundColor = AppColor.primary,
    this.fontSize,
    this.fontWeight,
    this.textColor = Colors.white,
    this.elevation,
    this.borderRadius,
    this.isLoading = false,
    this.padding,
    this.useBorder = false,
    this.foregroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (text != null && textWidget != null) {
      throw Exception('text 와 textWidget 둘 중 하나만 사용할 수 있습니다.');
    }

    if (text == null && textWidget == null) {
      throw Exception('text 또는 textWidget 둘 중 하나는 반드시 존재해야합니다.');
    }

    return ElevatedButton(
      onPressed: isActive ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? backgroundColor : AppColor.grey500,
        shape: RoundedRectangleBorder(
            side: useBorder ? const BorderSide(color: AppColor.grey500) : const BorderSide(color: Colors.transparent),
            borderRadius: borderRadius ?? BorderRadius.circular(5.0.r)),
        elevation: elevation ?? 0.0,
        disabledBackgroundColor: AppColor.grey500,
        foregroundColor: AppColor.grey300,
        padding: padding,
      ),
      child: isLoading
          ? SizedBox(width: 24.0.h, height: 24.0.h, child: const CircularProgressIndicator(color: Colors.white))
          : textWidget ??
              Text(
                text!,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: fontSize ?? 14.0.sp,
                  fontWeight: fontWeight ?? FontWeight.w500,
                  color: isActive ? textColor : AppColor.grey550,
                )
              ),
    );
  }
}
