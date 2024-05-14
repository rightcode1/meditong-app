import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediport/core/component/buttons/common_button.dart';
import 'package:mediport/core/constant/app_color.dart';
import 'package:mediport/core/util/toast_utils.dart';
import 'package:mediport/domain/model/user/res/user_res.dart';
import 'package:mediport/service/user/provider/user_providers.dart';

import '../../../../core/enum/app_router.dart';

class MyInfoElement extends ConsumerWidget {
  /// 마이 탭 > 상단 내 정보 (로그인/비로그인 시 구분)
  const MyInfoElement({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userInfoProvider);
    return Padding(
      padding: EdgeInsets.only(left: 16.0.w, right: 16.0.w, top: 24.0.h, bottom: 32.0.h),
      child: user is UserRes
          ? Builder(
              builder: (context) {
                return IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 60.0.h,
                            height: 60.0.h,
                            child: const CircleAvatar(
                              backgroundColor: AppColor.grey300,
                            ),
                          ),
                          SizedBox(width: 10.0.w),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    user.name,
                                    style: TextStyle(fontSize: 20.0.sp, fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(width: 6.0.w),
                                  Text(
                                    '님',
                                    style: TextStyle(fontSize: 20.0.sp, fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                              Text(
                                '반가워요!',
                                style: TextStyle(fontSize: 20.0.sp, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 34.0.h,
                        child: OutlinedButton(
                          onPressed: () => ToastUtils.showToast(context, toastText: '이동 - 개인정보 수정'),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 4.0.h),
                            foregroundColor: AppColor.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0.r)),
                            side: const BorderSide(color: AppColor.grey500),
                            textStyle: TextStyle(
                              fontSize: 14.0.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColor.primary,
                            ),
                          ),
                          child: Text(
                            '개인정보 수정',
                          ),
                          // child: CommonButton(
                          //   fontSize: 14.0.sp,
                          //   fontWeight: FontWeight.w600,
                          //   textColor: AppColor.primary,
                          //   buttonColor: Colors.white,
                          //   text: '개인정보 수정',
                          //   onPressed: () => ToastUtils.showToast(context, toastText: '이동 - 개인정보 수정'),
                          // ),
                        ),
                      )
                    ],
                  ),
                );
              },
            )
          : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '메디포트',
                          style: TextStyle(fontSize: 20.0.sp, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          '를 이용하려면',
                          style: TextStyle(fontSize: 20.0.sp, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    Text(
                      '로그인이 필요합니다!',
                      style: TextStyle(fontSize: 20.0.sp, fontWeight: FontWeight.w400),
                    )
                    // CommonButton(
                    //   onPressed: () {
                    //     context.pushNamed(AppRouter.auth.name);
                    //   },
                    //   text: '임시 로그인',
                    // ),
                  ],
                ),
              ),
              CommonButton(
                useBorder: true,
                foregroundColor: AppColor.grey300,
                backgroundColor: Colors.white,
                textColor: AppColor.primary,
                onPressed: () => context.pushNamed(AppRouter.auth.name),
                text: '로그인',
              ),
            ],
          ),
    );
  }
}
