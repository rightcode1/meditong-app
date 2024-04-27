import 'package:meditong/core/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 가장 기본이 되는 버튼 컴포넌트, 형태에 맞게 재구성하여 사용한다.
class CommonOutlinedButton extends StatelessWidget {
  final bool isLoading;

  /// 버튼 텍스트
  final String text;

  /// 버튼 클릭 시 콜백
  final VoidCallback onPressed;

  /// 버튼 활성화 여부
  final bool isActive;

  /// 버튼 색상
  final Color? buttonColor;

  /// 폰트 사이즈
  final double? fontSize;

  /// 폰트 굵기
  final FontWeight? fontWeight;

  final double borderRadius;

  final Color? textColor;

  const CommonOutlinedButton({
    this.isLoading = false,
    required this.text,
    required this.onPressed,
    this.isActive = true,
    this.buttonColor = AppColor.green500,
    this.fontSize,
    this.fontWeight,
    this.borderRadius = 8,
    this.textColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isActive ? onPressed : null,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius.h),
            side: BorderSide(width: 2.0.h, color: isActive ? Colors.grey : AppColor.grey400)),
      ),
      child: isLoading
          ? SizedBox(
        height: 16.0.h,
        width: 16.0.h,
        child: const CircularProgressIndicator(
          color: Colors.black,
        ),
      )
          :  Text(
        text,
        style: TextStyle(
          fontSize: fontSize ?? 13.0.sp,
          fontWeight: fontWeight,
          color: textColor,
        ),
      ),
    );
  }
}
