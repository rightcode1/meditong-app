import 'package:meditong/core/component/buttons/common_button.dart';
import 'package:meditong/core/component/label/common_label.dart';
import 'package:meditong/core/component/text_fields/custom_form_builder_text_field.dart';
import 'package:meditong/core/constant/app_color.dart';
import 'package:meditong/core/layout/default_layout.dart';
import 'package:meditong/core/util/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

import '../../../../service/auth/join/auth_join_provider.dart';
import '../../enum/auth_enum.dart';
import '../../provider/form/join/auth_join_form_provider.dart';

/// 기본 형태의 회원가입 스크린, 형태에 맞게 재정의하여 사용한다.
class JoinScreen extends ConsumerStatefulWidget {
  /*
    SNS 가입 시 필요한 정보
   */
  final String? loginId;
  final String? snsProvider;

  const JoinScreen({
    this.loginId,
    this.snsProvider,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends ConsumerState<JoinScreen> {
  bool get _isSnsJoin => widget.snsProvider != null && widget.loginId != null;

  String? get _loginId => widget.loginId;

  String? get _snsProvider => widget.snsProvider;

  bool _isRegisterLoading = false;

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(authJoinFormProvider);

    // 휴대폰 번호 인증 시, 서버로부터 예외가 발생하였을 경우 반환되는 팝업
    // FIXME: 여러 번 안 뜨게 방지
    if (formState.verificationNumberStatus == AuthVerificationNumberStatus.failed) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        DialogUtils.showOneButton(
          context: context,
          title: '휴대폰 번호',
          content: '이미 등록한 휴대폰 번호이거나\n잘못된 번호 입니다.',
          buttonText: '확인',
          onButtonPressed: () {
            ref.read(authJoinFormProvider.notifier).changeVerificationNumberStatus(AuthVerificationNumberStatus.none);
            context.pop();
          },
        );
      });
    }

    return DefaultLayout(
      showAppBar: true,
      showBack: true,
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 30.0.h,
              ),
              // 회원가입 폼
              if (_isSnsJoin)
                Visibility(
                  maintainState: true,
                  visible: false,
                  child: FormBuilderTextField(
                    name: 'loginId',
                    initialValue: _loginId,
                  ),
                ),
              if (_isSnsJoin)
                Visibility(
                  maintainState: true,
                  visible: false,
                  child: FormBuilderTextField(
                    name: 'password',
                    initialValue: 'rightcode1234',
                  ),
                ),
              if (_isSnsJoin)
                Visibility(
                  maintainState: true,
                  visible: false,
                  child: FormBuilderTextField(
                    name: 'provider',
                    initialValue: _snsProvider,
                  ),
                ),
              if (!_isSnsJoin)
                CommonLabel(
                  label: '이메일',
                  child: CustomFormBuilderTextField(
                    name: 'loginId',
                    hintText: '이메일을 입력해주세요.',
                    maxLength: 30,
                    showCounterText: false,
                    keyboardType: TextInputType.emailAddress,
                    inputFormatters: [
                      FilteringTextInputFormatter.singleLineFormatter,
                      FilteringTextInputFormatter.deny(' ', replacementString: ''),
                    ],
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(errorText: '이메일을 입력해주세요.'),
                      FormBuilderValidators.email(errorText: '올바른 이메일을 입력해주세요.'),
                    ]),
                    // Debouncer 를 통해 동작한다.
                    onChanged: (nickname) async {
                      final pNickname = formState.formData['loginId'];
                      await ref.read(authJoinFormProvider.notifier).checkAvailableLoginId(pNickname, nickname!);
                    },
                    helperText: formState.isLoginIdVerified == AuthVerificationStatus.verified ? '사용할 수 있는 아이디입니다.' : null,
                    errorText: formState.isLoginIdVerified == AuthVerificationStatus.unverified ? '이미 존재하는 아이디입니다.' : null,
                  ),
                ),
              if (!_isSnsJoin)
                SizedBox(
                  height: 22.0.h,
                ),
              if (!_isSnsJoin)
                CommonLabel(
                  label: '비밀번호',
                  child: CustomFormBuilderTextField(
                    name: 'password',
                    obscureText: true,
                    hintText: '8-16자리 영문 대소문자, 숫자, 특수문자 중 3가지 이상',
                    hintStyle: TextStyle(
                      color: AppColor.grey400,
                      fontSize: 11.0.sp,
                    ),
                    helperText: formState.isPasswordVerified == AuthVerificationStatus.verified ? '사용할 수 있는 비밀번호입니다.' : null,
                    maxLength: 16,
                    showCounterText: false,
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      FilteringTextInputFormatter.singleLineFormatter,
                      FilteringTextInputFormatter.deny(' ', replacementString: ''),
                    ],
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(errorText: '비밀번호를 입력해주세요.'),
                      FormBuilderValidators.match(r"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,20}$",
                          errorText: '최소 8자리 이상 문자, 숫자, 특수문자 포함'),
                    ]),
                    onChanged: (value) {
                      if (value != null) {
                        final pPassword = formState.formData['password'];
                        ref.read(authJoinFormProvider.notifier).checkAvailablePassword(pPassword, value);
                      }
                    },
                  ),
                ),
              if (!_isSnsJoin)
                CommonLabel(
                  label: '비밀번호 확인',
                  child: CustomFormBuilderTextField(
                    name: 'passwordConfirm',
                    hintText: '비밀번호 확인',
                    obscureText: true,
                    maxLength: 16,
                    showCounterText: false,
                    keyboardType: TextInputType.text,
                    helperText: formState.isPasswordConfirmVerified == AuthVerificationStatus.verified ? '비밀번호가 일치합니다.' : null,
                    errorText: formState.isPasswordConfirmVerified == AuthVerificationStatus.unverified ||
                        formState.isPasswordConfirmVerified == AuthVerificationStatus.none
                        ? '비밀번호가 일치하지 않습니다.'
                        : null,
                    inputFormatters: [
                      FilteringTextInputFormatter.singleLineFormatter,
                      FilteringTextInputFormatter.deny(' ', replacementString: ''),
                    ],
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(errorText: '비밀번호 확인란을 입력해주세요.'),
                    ]),
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(authJoinFormProvider.notifier).checkPasswordConfirmEqualToPassword(value);
                      }
                    },
                  ),
                ),
              if (!_isSnsJoin)
                SizedBox(
                  height: 22.0.h,
                ),
              CommonLabel(
                label: '이름',
                child: CustomFormBuilderTextField(
                  name: 'name',
                  hintText: '실명 기입',
                  maxLength: 15,
                  showCounterText: false,
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    FilteringTextInputFormatter.singleLineFormatter,
                    FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9ㄱ-힣ㆍᆢ]'), replacementString: ''),
                  ],
                  validator: FormBuilderValidators.required(errorText: '성함을 입력해주세요.'),
                ),
              ),
              SizedBox(
                height: 22.0.h,
              ),
              CommonLabel(
                label: '휴대폰 번호',
                child: CustomFormBuilderTextField(
                  name: 'tel',
                  hintText: '- 없이 입력',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    FilteringTextInputFormatter.deny(' ', replacementString: ''),
                  ],
                  validator: FormBuilderValidators.required(errorText: '휴대폰 번호를 입력해주세요.'),
                  enabled: formState.verificationNumberStatus == AuthVerificationNumberStatus.none,
                ),
              ),
              SizedBox(height: 10.0.h),
              SizedBox(
                width: double.infinity,
                // child: ElevatedButton(onPressed: () {}, child: Text('인증 번호 받기')),
                child: SizedBox(
                  height: 40.0.h,
                  child: CommonButton(
                    buttonColor: AppColor.green500,
                    text: formState.verificationNumberStatus == AuthVerificationNumberStatus.none ? '인증 번호 받기' : '인증 번호 전송 완료!',
                    // FIXME: 휴대폰 정규식 도입 고려
                    // 인증번호 받기가 전송된 상태가 아닐 경우, 전화번호가 10자 이상인 경우 버튼을 활성화시킨다.
                    isActive: formState.verificationNumberStatus == AuthVerificationNumberStatus.none && formState.formData['tel'].toString().length >= 10,
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      ref.read(authJoinFormProvider.notifier).sendVerificationNumber();
                    },
                    // height: 40.0.h,
                    fontSize: 12.0.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: 22.0.h,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row 안에서 TextFormField 는 Width 가 얼마나 될지 Flutter 가 판단할 수 없다. 따라서 Expanded 를 적용한다.
                  Expanded(
                    child: CustomFormBuilderTextField(
                      name: 'verificationNumber',
                      hintText: '인증번호 입력',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      // 인증번호가 전송된 상태에서만 Input 을 활성화시킨다.
                      enabled: formState.verificationNumberStatus != AuthVerificationNumberStatus.none &&
                          formState.verificationNumberStatus != AuthVerificationNumberStatus.confirmed,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(errorText: '인증번호를 입력해주세요.'),
                      ]),
                      helperText: formState.verificationNumberStatus == AuthVerificationNumberStatus.confirmed ? '인증이 완료되었습니다.' : null,
                      errorText: formState.verificationNumberStatus == AuthVerificationNumberStatus.invalid ? '인증번호가 올바르지 않습니다.' : null,
                    ),
                  ),
                  SizedBox(
                    width: 10.0.w,
                  ),
                  SizedBox(
                    height: 53.0.h,
                    child: CommonButton(
                      buttonColor: AppColor.green500,
                      text: '확인',
                      // 인증번호 전송 상태가 초기 상태가 아니고, 인증에 성공한 상황이 아닐 경우에만 인증완료 버튼을 활성화시킨다.
                      isActive: formState.verificationNumberStatus != AuthVerificationNumberStatus.none &&
                          formState.verificationNumberStatus != AuthVerificationNumberStatus.confirmed,
                      onPressed: () async {
                        final confirmed = await ref.read(authJoinFormProvider.notifier).checkVerificationNumber();
                        if (confirmed) {
                        } else {}
                      },
                      fontSize: 12.0.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 40.0.h,
              ),
              // Consumer 를 통해 authJoinFormProvider 의 상태가 변경될 때 버튼만 리빌드 될 수 있도록 한다.
              SizedBox(
                height: 50.0.h,
                child: Consumer(
                  builder: (context, ref, child) {
                    final formState = ref.watch(authJoinFormProvider);

                    return CommonButton(
                      text: '회원가입',
                      isActive: _isSnsJoin
                          ? formState.isCommonSnsAllValidated
                          : formState.isCommonAllValidated &&
                          !_isRegisterLoading,
                      isLoading: _isRegisterLoading,
                      onPressed: () async {
                        // 현재 Form 데이터를 Model 로 변환 후, 서버로 전송한다..
                        await ref.read(authJoinProvider.notifier).join();
                        if (context.mounted) {
                          context.pop();
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
