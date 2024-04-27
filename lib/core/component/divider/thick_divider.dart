import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediport/core/constant/app_color.dart';

class ThickDivider extends StatelessWidget {
  final double? height;

  const ThickDivider({
    this.height,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: 10.0.h,
      height: height ?? 0.0.h,
      color: AppColor.grey400,
    );
  }
}
