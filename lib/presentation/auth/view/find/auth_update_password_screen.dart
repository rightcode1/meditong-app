import 'dart:io';

import 'package:meditong/core/component/.etc/custom_will_pop_scope.dart';
import 'package:meditong/core/constant/app_color.dart';
import 'package:meditong/core/layout/default_layout.dart';
import 'package:meditong/core/util/bottom_sheet_utils.dart';
import 'package:meditong/core/util/toast_utils.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../service/auth/auth_cert_provider.dart';
import '../../../../service/auth/auth_password_change_async_provider.dart';
import '../../component/element/auth_update_password_element.dart';
import '../../enum/auth_enum.dart';
import '../../provider/form/find/auth_find_password_form_provider.dart';

class AuthUpdatePasswordScreen extends ConsumerStatefulWidget {
  static get routeName => 'AuthUpdatePasswordScreen';

  /// 비밀번호 변경 공용 스크린
  const AuthUpdatePasswordScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AuthUpdatePasswordScreen> createState() => _AuthUpdatePasswordScreenState();
}

class _AuthUpdatePasswordScreenState extends ConsumerState<AuthUpdatePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(authFindPasswordFormProvider);
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;

        context
          ..pop()
          ..pop();
      },
      child: DefaultLayout(
        showAppBar: true,
        showBack: true,
        onBackPressed: () {
          context
            ..pop()
            ..pop();
        },
        title: '비밀번호 변경',
        child: AuthUpdatePasswordElement(
          isPasswordVerified: formState.verificationStatusOfPassword == AuthVerificationStatus.verified,
          isPasswordConfirmVerified: formState.verificationStatusOfPasswordConfirm == AuthVerificationStatus.none
              ? null
              : formState.verificationStatusOfPasswordConfirm == AuthVerificationStatus.verified
                  ? true
                  : false,
          onPasswordChanged: (password) {
            if (password != null) {
              final trim = password.trim();
              EasyDebounce.debounce('checkAvailablePassword', const Duration(milliseconds: 300), () {
                // 비밀번호 변경 즉시, 기존 비밀번호 인증 상태를 none 으로 변경한다.
                if (formState.verificationStatusOfPassword != AuthVerificationStatus.none ||
                    formState.verificationStatusOfPasswordConfirm != AuthVerificationStatus.none) {
                  ref.read(authFindPasswordFormProvider.notifier).changeVerificationStatusOfPassword(AuthVerificationStatus.none);
                  ref.read(authFindPasswordFormProvider.notifier).changeVerificationStatusOfPasswordConfirm(AuthVerificationStatus.none);
                }

                ref.read(authCertProvider.notifier).checkAvailablePassword(
                      password: trim,
                      onSucceed: (status) {
                        ref.read(authFindPasswordFormProvider.notifier).changeVerificationStatusOfPassword(status);
                        ref.read(authFindPasswordFormProvider.notifier).changePassword(trim);
                      },
                      onFailed: (status) {
                        ref.read(authFindPasswordFormProvider.notifier).changeVerificationStatusOfPassword(status);
                      },
                    );
              });
            }
          },
          onPasswordConfirmChanged: (passwordConfirm) {
            if (passwordConfirm != null) {
              final trim = passwordConfirm.trim();
              EasyDebounce.debounce('checkPasswordConfirmEqualToPassword', const Duration(milliseconds: 300), () {
                ref.read(authCertProvider.notifier).checkIfPasswordConfirmEqualToPassword(
                      password: formState.password,
                      passwordConfirm: trim,
                      onSucceed: (status) {
                        ref.read(authFindPasswordFormProvider.notifier).changeVerificationStatusOfPasswordConfirm(status);
                      },
                      onFailed: (status) {
                        ref.read(authFindPasswordFormProvider.notifier).changeVerificationStatusOfPasswordConfirm(status);
                      },
                    );
              });
            }
          },
          onCompleteBtnClicked: () async {
            final result = await ref.read(authPasswordChangeAsyncProvider.notifier).sendToServerForLostPassword();

            if (context.mounted) {
              final statusCode = result['statusCode'];
              final message = result['message'];
              if (statusCode == HttpStatus.ok) {
                BottomSheetUtils.showOneButton(
                  context: context,
                  isDismissible: false,
                  enableDrag: false,
                  title: '비밀번호 변경 완료',
                  contentWidget: (bottomState) {
                    return Text(
                      '로그인을 통해서 웰카를 즐겨보세요!',
                      style: TextStyle(
                        fontSize: 14.0.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColor.darkGrey500,
                      ),
                    );
                  },
                  buttonText: '로그인',
                  onButtonPressed: () {
                    Navigator.of(context)
                      ..pop()
                      ..pop()
                      ..pop();
                  },
                );
              } else {
                ToastUtils.showToast(context, toastText: message);
                context
                  ..pop()
                  ..pop();
              }
            }
          },
        ),
      ),
    );
  }
}
