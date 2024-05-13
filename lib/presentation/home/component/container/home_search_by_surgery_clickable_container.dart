import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediport/core/constant/app_color.dart';

class HomeSearchBySurgeryClickableContainer extends StatelessWidget {
  /// 홈 > 시술별 검색 내에서 사용되는 컨테이너
  const HomeSearchBySurgeryClickableContainer({
    super.key,
    required this.iconPath,
    required this.hashtag,
    required this.description,
    required this.onPressed,
  });

  final String iconPath;
  final String hashtag;
  final String description;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        constraints: BoxConstraints(minWidth: 102.0.w, maxWidth: 150.0.w),
        padding: EdgeInsets.symmetric(horizontal: 10.0.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0.r),
          border: Border.all(color: AppColor.grey500),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              iconPath,
              height: 20.0.h,
            ),
            SizedBox(height: 14.0.h),
            Text(
              hashtag,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14.0.sp, fontWeight: FontWeight.w600, color: AppColor.primary),
            ),
            SizedBox(height: 1.0.h),
            Text(
              description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12.0.sp, fontWeight: FontWeight.w400, color: AppColor.cyan700),
            )
          ],
        ),
      ),
    );
  }
}
