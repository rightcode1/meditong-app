import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediport/core/component/buttons/common_button.dart';
import 'package:mediport/core/constant/app_color.dart';

class HomeElementTitleContainer extends StatelessWidget {
  /// 홈 내 각 엘리먼트 상단에 부착되어 사용되는 타이틀 컨테이너
  const HomeElementTitleContainer({
    super.key,
    required this.title,
    required this.content,
    required this.onAllButtonClicked,
  });

  final String title;
  final String content;
  final VoidCallback onAllButtonClicked;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0.w, right: 16.0.w, bottom: 24.0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /* title and onAllButtonClicked */
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(
                height: 34.0.h,
                child: CommonButton(
                  useBorder: true,
                  foregroundColor: AppColor.grey300,
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 4.0.h),
                  fontSize: 14.0.sp,
                  textColor: AppColor.primary,
                  onPressed: onAllButtonClicked,
                  text: '전체보기',
                ),
              ),
            ],
          ),
          /* content */
          SizedBox(height: 2.0.h),
          Text(
            content,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(color: AppColor.cyan700),
          ),
        ],
      ),
    );
  }
}
