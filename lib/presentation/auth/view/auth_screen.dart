import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediport/core/constant/app_color.dart';
import 'package:mediport/core/enum/app_router.dart';
import 'package:mediport/core/layout/default_layout.dart';
import 'package:mediport/core/util/go_router_utils.dart';
import 'package:mediport/domain/repository/version/version_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../component/login/column/auth_login_button_column.dart';
import '../component/login/form/auth_login_form_column.dart';
import '../component/login/row/auth_login_find_row.dart';
import '../provider/form/login/auth_login_form_provider.dart';

/// 기본 형태의 로그인 스크린, 형태에 맞게 재정의하여 사용한다.
class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool _enableSocialLogin = false;

  /// 로그인 로딩 여부
  bool _isLoginLoading = false;

  @override
  void initState() {
    super.initState();

    getInitialData();
  }

  Future<void> getInitialData() async {
    ref.read(versionRepositoryProvider).version().then((value) async {
      late int socialVersion;
      final data = value.data!;

      if (Platform.isAndroid) {
        socialVersion = data.aosSocialVer;
      } else if (Platform.isIOS) {
        socialVersion = data.iosSocialVer;
      }
      final int currentAppVersion = await PackageInfo.fromPlatform().then((info) => int.parse(info.buildNumber));
      debugPrint('===> Current app version: $currentAppVersion');
      debugPrint('===> Social version: $socialVersion');

      _enableSocialLogin = currentAppVersion <= socialVersion;

      // _enableSocialLogin = true;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(authLoginFormProvider);
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;

        /// 로그인 화면을 닫는 경우, 원래 기이동하려고 했던 화면 라우팅을 포기한 것이라고 해석할 수 있다.
        /// 따라서, X 또는 뒤로가기 할 경우, 원래 이동하려고 했던 라우트를 쿠키에서 제거한다.
        GoRouterUtils.removeExpectedRoute(ref);

        !context.canPop() ? context.goNamed(AppRouter.home.name) : context.pop();
      },
      child: DefaultLayout(
          showAppBar: true,
          showClose: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'medical\ntreatment',
                style: TextStyle(
                  fontSize: 24.0.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColor.primary,
                ),
              ),
              SizedBox(height: 8.0.h),
              Text(
                '모든 의료 뉴스를 한곳에',
                style: TextStyle(
                  fontSize: 16.0.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20.0.h),
              Expanded(
                child: Column(
                  children: [
                    // 로그인 폼
                    AuthLoginFormColumn(
                      onLoginIdChanged: (loginId) {
                        if (loginId != null) {
                          ref.read(authLoginFormProvider.notifier).changeLoginId(loginId.trim());
                        }
                      },
                      onPasswordChanged: (password) {
                        if (password != null) {
                          ref.read(authLoginFormProvider.notifier).changePassword(password.trim());
                        }
                      },
                    ),
                    AuthLoginFindRow(
                      onFindIdBtnClicked: () => context.push(AppRouter.findId.path),
                      onFindPasswordBtnClicked: () => context.push(AppRouter.findPassword.path),
                    ),
                    SizedBox(
                      height: 15.5.h,
                    ),
                    // 회원가입 및 로그인 버튼
                    AuthLoginButtonColumn(
                      isLoginLoading: _isLoginLoading,
                      canLogin: formState.isAllValidated,
                      onLoginBtnClicked: () async {
                        // TODO: 실 로직 작성 시, 하기 로직 제거
                        GoRouterUtils.moveToExpectedRouteAfterSingingIn(context, ref);

                        // TODO: 실 로직 작성 시, 하기 주석 해제하여 사용한다.
                        // try {
                        //   setState(() {
                        //     _isLoginLoading = true;
                        //   });
                        //   final result = await ref.read(authLoginProvider.future);
                        //
                        //   if (!context.mounted) return;
                        //
                        //   // 로그인에 실패했을 경우 (아이디 혹은 비밀번호 불일치)
                        //   if (!result) {
                        //     DialogUtils.showOneButtonDialog(
                        //       context: context,
                        //       title: '로그인 실패!',
                        //       content: '아이디 혹은 비밀번호가\n올바르지 않습니다.',
                        //       buttonText: '확인',
                        //       onButtonPressed: () {
                        //         context.pop();
                        //       },
                        //     );
                        //   }
                        //   // 로그인 성공 시, 기존에 이동하려고 했던 페이지로 이동한다.
                        //   GoRouterUtils.moveToExpectedRouteAfterSingingIn(context, ref);
                        // } on RequestException catch (err, stack) {
                        //   ToastUtils.showToast(context, toastText: err.message);
                        // } finally {
                        //   setState(() {
                        //     _isLoginLoading = false;
                        //   });
                        // }
                      },
                      onJoinBtnClicked: () {
                        context.push(AppRouter.join.path);
                      },
                    ),
                  ],
                ),
              ),
              // 아이디 찾기 및 비밀번호 찾기 텍스트 버튼

              /*
                        SNS 로그인 버튼
                       */
              // if (_enableSocialLogin) const AuthSnsLoginButtonColumn(),
              // if (_enableSocialLogin) SizedBox(height: 48.0.h),
            ],
          )),
    );
  }
}
