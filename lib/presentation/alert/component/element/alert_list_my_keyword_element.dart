import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediport/core/component/chip/common_chip.dart';
import 'package:mediport/core/constant/app_color.dart';
import 'package:mediport/service/alert/alert_providers.dart';

class AlertListMyKeywordElement extends ConsumerWidget {
  /// 알람 > 나의 키워드 엘리먼트
  const AlertListMyKeywordElement({
    super.key,
    required this.onRegisterPressed,
  });

  final VoidCallback onRegisterPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alertList = ref.watch(alertProvider);
    return Padding(
      padding: EdgeInsets.only(left: 16.0.w, right: 16.0.w, top: 20.0.h, bottom: 30.0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '나의 키워드',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600, color: AppColor.cyan700),
              ),
              IconButton(
                onPressed: onRegisterPressed,
                icon: Image.asset('assets/icons/common/write_primary@3x.png', height: 24.0.h),
              ),
            ],
          ),
          SizedBox(height: 4.0.h),
          Wrap(
            spacing: 10.0.w,
            runSpacing: 10.0.h,
            children: alertList.value!
                .map((e) => CommonChip(
                      padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 8.0.h),
                      borderRadius: BorderRadius.circular(9999),
                      backgroundColor: Colors.white,
                      useBorder: true,
                      text: e.content,
                      fontSize: 14.0.sp,
                      textColor: AppColor.primary,
                    ))
                .toList(),
          )
        ],
      ),
    );
  }
}
