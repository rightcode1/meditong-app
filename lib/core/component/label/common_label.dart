import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediport/core/constant/app_color.dart';

class CommonLabel extends StatelessWidget {
  /// String 형태의 라벨
  final String? label;

  /// 위젯 형태로 구성된 라벨
  final Widget? labelWidget;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Widget child;

  const CommonLabel({
    this.label,
    this.labelWidget,
    this.fontSize,
    this.fontWeight,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (label == null && labelWidget == null) {
      throw Exception('label, labelWidget 는 모두 null 일 수 없습니다.');
    }

    if (label != null && labelWidget != null) {
      throw Exception('label 과 labelWidget 을 동시에 사용할 수 없습니다.');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10.0.h),
          child: label != null
              ? Text(
                  label!,
                  style: TextStyle(
                    fontSize: fontSize ?? 14.0.sp,
                    fontWeight: fontWeight ?? FontWeight.w600,
                    color: AppColor.cyan700
                  ),
                )
              : labelWidget,
        ),
        child,
      ],
    );
  }
}
