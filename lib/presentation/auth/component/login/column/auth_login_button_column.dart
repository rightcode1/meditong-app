import 'package:meditong/core/component/buttons/common_button.dart';
import 'package:meditong/core/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 로그인 / 회원가입 버튼 컬럼 컴포넌트, 형태에 맞게 적절히 변형하여 사용한다.
class AuthLoginButtonColumn extends ConsumerWidget {
  const AuthLoginButtonColumn({
    Key? key,
    required this.isLoginLoading,
    required this.canLogin,
    required this.onLoginBtnClicked,
    required this.onJoinBtnClicked,
  }) : super(key: key);
  final bool isLoginLoading;
  final bool canLogin;
  final VoidCallback onLoginBtnClicked;
  final VoidCallback onJoinBtnClicked;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 50.0.h,
          child: CommonButton(
            isLoading: isLoginLoading,
            isActive: !isLoginLoading && canLogin,
            text: '로그인',
            onPressed: onLoginBtnClicked,
            buttonColor: AppColor.green500,
            fontSize: 15.0.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 8.5.h,
        ),
        SizedBox(
          height: 50.0.h,
          child: CommonButton(
            text: '회원가입',
            onPressed: onJoinBtnClicked,
            buttonColor: AppColor.green500,
            fontSize: 15.0.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
