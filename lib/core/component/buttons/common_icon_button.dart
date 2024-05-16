import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediport/core/constant/app_color.dart';

class CommonIconButton extends StatelessWidget {
  /// 앱 내에서 사용되는 기본적인 형태의 아이콘 버튼
  const CommonIconButton({
    super.key,
    required this.iconPath,
    required this.text,
    required this.onPressed,
  });

  final String iconPath;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(5.0.r),
      onTap: onPressed,
      child: Ink(
        padding: EdgeInsets.symmetric(horizontal: 14.0.w, vertical: 12.0.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0.r),
          border: Border.all(color: AppColor.grey300),
        ),
        child: Row(
          children: [
            Image.asset(iconPath, height: 20.0.h),
            SizedBox(width: 4.0.w),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColor.cyan700,
              )
            ),
          ],
        ),
      ),
    );
  }
}
