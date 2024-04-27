import 'dart:io';

import 'package:meditong/core/constant/app_color.dart';
import 'package:meditong/core/enum/app_router.dart';
import 'package:meditong/presentation/auth/enum/auth_enum.dart';
import 'package:meditong/service/auth/login/auth_social_login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthSnsLoginButtonColumn extends ConsumerWidget {
  const AuthSnsLoginButtonColumn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const Color borderColor = Color.fromRGBO(221, 221, 221, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Divider(
              color: borderColor,
              thickness: 1.0.w,
              height: 0.0,
            )),
            SizedBox(
              width: 8.5.w,
            ),
            Text(
              'SNS 로그인',
              style: TextStyle(
                fontSize: 12.0.sp,
                fontWeight: FontWeight.w400,
                color: AppColor.grey500,
              ),
            ),
            SizedBox(
              width: 8.5.w,
            ),
            Expanded(
                child: Divider(
              color: borderColor,
              thickness: 1.0.w,
              height: 0.0,
            )),
          ],
        ),
        SizedBox(
          height: 24.0.h,
        ),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 16.0.w,
          children: [
            GestureDetector(
              onTap: () async {
                debugPrint('카카오 로그인');
                // AuthUtils 를 통해 카카오 로그인을 시도한다.
                final bool isSignedUp = await ref.read(authSocialLoginProvider.notifier).signIn(snsProvider: AuthSnsProvider.kakao);

                if (context.mounted) {
                  if (isSignedUp) {
                    // context.go(AppRouter.home.path);
                  } else {
                    context.pushNamed(AppRouter.join.name, queryParameters: {
                      'role': '일반',
                      'loginId': await UserApi.instance.me().then((me) => me.id.toString()),
                      'snsProvider': AuthSnsProvider.kakao.name,
                    });
                  }
                }
              },
              child: Image.asset(
                'assets/images/auth/kakao@3x.png',
                height: 47.0.h,
              ),
            ),
            // 네이버 로그인
            GestureDetector(
              onTap: () async {
                debugPrint('네이버 로그인');
                // AuthUtils 를 통해 네이버 로그인을 시도한다.
                final bool isSignedUp = await ref.read(authSocialLoginProvider.notifier).signIn(snsProvider: AuthSnsProvider.naver);

                if (context.mounted) {
                  if (isSignedUp) {
                    // context.go(AppRouter.home.path);
                  } else {
                    context.pushNamed(AppRouter.join.name, queryParameters: {
                      'role': '일반',
                      'loginId': await FlutterNaverLogin.currentAccount().then((value) => value.id),
                      'snsProvider': AuthSnsProvider.naver.name,
                    });
                  }
                }
              },
              child: Image.asset(
                'assets/images/auth/naver@3x.png',
                height: 47.0.h,
              ),
            ),
            if (Platform.isIOS)
              GestureDetector(
                onTap: () async {
                  debugPrint('애플 로그인');
                  // AuthUtils 를 통해 네이버 로그인을 시도한다.
                  final bool isSignedUp = await ref.read(authSocialLoginProvider.notifier).signIn(snsProvider: AuthSnsProvider.apple);

                  final prefs = await SharedPreferences.getInstance();

                  if (context.mounted) {
                    if (isSignedUp) {
                      // context.go(AppRouter.home.path);
                    } else {
                      context.pushNamed(AppRouter.join.name, queryParameters: {
                        'role': '일반',
                        'loginId': prefs.getString('appleIdentifier'),
                        'snsProvider': AuthSnsProvider.apple.name,
                      });

                      prefs.remove('appleIdentifier');
                    }
                  }
                },
                child: Image.asset(
                  'assets/images/auth/apple@3x.png',
                  height: 47.0.h,
                ),
              ),
          ],
        )
      ],
    );
  }
}
