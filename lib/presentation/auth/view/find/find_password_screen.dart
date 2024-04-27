import 'package:meditong/core/component/buttons/common_button.dart';
import 'package:meditong/core/component/label/common_label.dart';
import 'package:meditong/core/component/text_fields/custom_form_builder_text_field.dart';
import 'package:meditong/core/layout/default_layout.dart';
import 'package:meditong/core/util/toast_utils.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../service/auth/auth_cert_provider.dart';
import '../../enum/auth_enum.dart';
import '../../provider/form/find/auth_find_password_form_provider.dart';
import 'auth_update_password_screen.dart';

class FindPasswordScreen extends ConsumerWidget {
  const FindPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(authFindPasswordFormProvider);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: DefaultLayout(
        showAppBar: true,
        showBack: true,
        title: '비밀번호 변경',
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CommonLabel(
                          label: '이메일',
                          child: CustomFormBuilderTextField(
                            name: 'loginId',
                            hintText: '가입하셨던 아이디를 입력하세요.',
                            onChanged: (value) {
                              if (value != null) {
                                final trim = value.trim();
                                ref.read(authFindPasswordFormProvider.notifier).changeLoginId(trim);
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 40.0.h),
                        CommonLabel(
                          label: '휴대폰 인증',
                          child: CustomFormBuilderTextField(
                            enabled: formState.verificationNumberStatus != AuthVerificationNumberStatus.confirmed && formState.verificationNumberStatus != AuthVerificationNumberStatus.sent,
                            name: 'tel',
                            hintText: '휴대폰 번호를 입력하세요.',
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                ref.read(authFindPasswordFormProvider.notifier).changeTel(value);
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 10.0.h),
                        SizedBox(
                          height: 50.0.h,
                          child: CommonButton(
                            isActive:
                            formState.tel != null && formState.tel!.length >= 10 && formState.verificationNumberStatus == AuthVerificationNumberStatus.none,
                            elevation: 0.0,
                            fontSize: 14.0.sp,
                            fontWeight: FontWeight.w500,
                            onPressed: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              await ref.read(authCertProvider.notifier).sendVerificationCode(
                                tel: formState.tel!,
                                diff: AuthDiff.find,
                                onSending: (status) {
                                  ref.read(authFindPasswordFormProvider.notifier).changeVerificationNumberStatus(status);
                                },
                                onSent: (status) {
                                  ToastUtils.showToast(context, toastText: '인증번호가 전송되었습니다.');
                                  ref.read(authFindPasswordFormProvider.notifier).changeVerificationNumberStatus(status);
                                },
                                onAlreadyExistsError: (status) {
                                  ref.read(authFindPasswordFormProvider.notifier).changeVerificationNumberStatus(status);
                                },
                                onTooManyRequestsError: (status) {
                                  ToastUtils.showToast(context, toastText: '5초에 한 번만 요청할 수 있습니다.');
                                  ref.read(authFindPasswordFormProvider.notifier).changeVerificationNumberStatus(status);
                                },
                                onInvalidFormatError: (status) {
                                  ref.read(authFindPasswordFormProvider.notifier).changeVerificationNumberStatus(status);
                                },
                                onUnknownError: (status) {
                                  ref.read(authFindPasswordFormProvider.notifier).changeVerificationNumberStatus(status);
                                },
                              );
                              // ref.read(authJoinFormProvider.notifier).sendVerificationNumber();
                            },
                            text: '인증 번호 받기',
                          ),
                        ),
                        SizedBox(height: 40.0.h),
                        if (formState.verificationNumberStatus != AuthVerificationNumberStatus.none)
                          CommonLabel(
                            label: '인증번호 입력',
                            child: CustomFormBuilderTextField(
                              enabled: formState.verificationNumberStatus != AuthVerificationNumberStatus.confirmed,
                              name: 'verificationNumber',
                              hintText: '인증번호를 입력하세요.',
                              helperText: formState.verificationNumberStatus == AuthVerificationNumberStatus.confirmed ? '인증되었습니다!' : null,
                              errorText: formState.verificationNumberStatus == AuthVerificationNumberStatus.invalid ? '인증에 실패했습니다.' : null,
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              showCounterText: false,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (value) {
                                if (value != null && value.length == 6) {
                                  EasyDebounce.debounce('verify', const Duration(milliseconds: 300), () async {
                                    await ref.read(authCertProvider.notifier).verifyNumber(
                                      tel: formState.tel!,
                                      verificationNumber: value,
                                      onSucceed: (status) {
                                        ref.read(authFindPasswordFormProvider.notifier).changeVerificationNumberStatus(status);
                                      },
                                      onFailed: (status) {
                                        ref.read(authFindPasswordFormProvider.notifier).changeVerificationNumberStatus(status);
                                      },
                                      onUnknownError: (status) {
                                        ToastUtils.showToast(context, toastText: '예기치 못한 오류가 발생했습니다.');
                                        ref.read(authFindPasswordFormProvider.notifier).changeVerificationNumberStatus(status);
                                      },
                                    );
                                  });
                                }
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0.h),
                    child: SizedBox(
                      height: 60.0.h,
                      child: CommonButton(
                        isActive: formState.canUpdatePassword,
                        elevation: 0.0,
                        fontSize: 16.0.sp,
                        fontWeight: FontWeight.w500,
                        text: '다음',
                        onPressed: () async {
                          context.pushNamed(AuthUpdatePasswordScreen.routeName);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
