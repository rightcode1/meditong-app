import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediport/core/component/buttons/common_icon_button.dart';
import 'package:mediport/core/component/divider/thick_divider.dart';
import 'package:mediport/core/constant/app_color.dart';
import 'package:mediport/core/layout/default_layout.dart';
import 'package:mediport/core/util/bottom_sheet_utils.dart';
import 'package:mediport/core/util/core_utils.dart';
import 'package:mediport/core/util/toast_utils.dart';
import 'package:mediport/domain/model/user/res/user_res.dart';
import 'package:mediport/presentation/my/component/element/my_info_element.dart';
import 'package:mediport/service/user/provider/user_providers.dart';

class MyScreen extends ConsumerWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userInfoProvider);
    return PopScope(
      onPopInvoked: (didPop) => CoreUtils.appExitWithBackButton(context),
      child: DefaultLayout(
        showAppBar: true,
        showBack: true,
        title: '마이',
        padding: EdgeInsets.zero,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /* 내 정보 및 개인정보 수정 */
              const MyInfoElement(),
              const ThickDivider(),
              SizedBox(height: 20.0.h),
              /* 공지사항, 1:1 문의 등 버튼 */
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                child: Column(
                  children: [
                    CommonIconButton(
                      iconPath: 'assets/icons/common/notice@3x.png',
                      text: '공지사항',
                      onPressed: () => ToastUtils.showToast(context, toastText: '이동 - 공지사항'),
                    ),
                    SizedBox(height: 14.0.w),
                    CommonIconButton(
                      iconPath: 'assets/icons/common/inquiry@3x.png',
                      text: '1:1 문의',
                      onPressed: () => ToastUtils.showToast(context, toastText: '이동 - 1:1 문의'),
                    ),
                    SizedBox(height: 14.0.w),
                    CommonIconButton(
                      iconPath: 'assets/icons/common/notification@3x.png',
                      text: '푸시알림',
                      onPressed: () => ToastUtils.showToast(context, toastText: '이동 - 푸시알림'),
                    ),
                  ],
                ),
              ),
              /* 로그아웃 버튼 */
              if (user is UserRes)
                Padding(
                  padding: EdgeInsets.only(left: 16.0.w, right: 16.0.w, top: 100.0.h),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            BottomSheetUtils.showTwoButton(
                              context: context,
                              title: '로그아웃',
                              contentWidget: (bottomState) {
                                return Text(
                                  '로그아웃 하시겠습니까?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.w400),
                                );
                              },
                              leftButtonText: '취소',
                              onLeftButtonPressed: () => context.pop(),
                              rightButtonText: '로그아웃',
                              onRightButtonPressed: () {
                                context.pop();
                                ref.read(userLogoutProvider);
                              },
                            );
                          },
                          child: Text(
                            '로그아웃',
                            style: TextStyle(fontSize: 14.0.sp, fontWeight: FontWeight.w600, color: AppColor.cyan700),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              /* Footer */
              SizedBox(height: 30.0.h),
              Container(
                padding: EdgeInsets.only(left: 16.0.w, right: 16.0.w, top: 20.0.h, bottom: 84.0.h),
                color: AppColor.grey400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '의료 플랫폼',
                      style: TextStyle(fontSize: 14.0.sp, fontWeight: FontWeight.w600, color: AppColor.darkGrey300),
                    ),
                    SizedBox(height: 10.0.h),
                    Text(
                      '대표: 홍길동\n사업자 번호: 00-000-0000\n주소: 서울특별시 강남구 테헤란 00-0000',
                      style: TextStyle(fontSize: 12.0.sp, fontWeight: FontWeight.w400, color: AppColor.darkGrey300),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
