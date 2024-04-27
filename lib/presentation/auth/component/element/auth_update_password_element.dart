import 'package:mediport/core/component/buttons/common_button.dart';
import 'package:mediport/core/component/label/common_label.dart';
import 'package:mediport/core/component/text_fields/custom_form_builder_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AuthUpdatePasswordElement extends ConsumerStatefulWidget {
  /// 비밀번호 변경 화면 내에서 사용하는 엘리먼트
  ///
  /// [isPasswordVerified] 를 통해 비밀번호를 사용 가능한지에 대한 여부를 렌더링할 수 있다.
  /// [isPasswordConfirmVerified] 를 통해 비밀번호 확인이 완료되었는지에 대한 여부를 렌더링 할 수 있다.
  /// [onPasswordChanged] 를 통해 비밀번호 입력 시에 대한 콜백을 반환할 수 있다.
  /// [onPasswordConfirmChanged] 를 통해 비밀번호 확인 입력 시에 대한 콜백을 반환할 수 있다.
  /// [onCompleteBtnClicked] 를 통해 완료 버튼 클릭 시에 대한 콜백을 정의할 수 있다.
  const AuthUpdatePasswordElement({
    required this.isPasswordVerified,
    this.isPasswordConfirmVerified,
    required this.onPasswordChanged,
    required this.onPasswordConfirmChanged,
    required this.onCompleteBtnClicked,
    Key? key,
  }) : super(key: key);

  final bool isPasswordVerified;
  final bool? isPasswordConfirmVerified;
  final Function(String? password) onPasswordChanged;
  final Function(String? passwordConfirm) onPasswordConfirmChanged;
  final Future<void> Function() onCompleteBtnClicked;

  @override
  ConsumerState<AuthUpdatePasswordElement> createState() => _AuthUpdatePasswordElementState();
}

class _AuthUpdatePasswordElementState extends ConsumerState<AuthUpdatePasswordElement> {
  final _passwordConfirmTextEditingController = TextEditingController();

  bool _isUpdateLoading = false;

  @override
  void dispose() {
    _passwordConfirmTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Column(
            children: [
              CommonLabel(
                label: '비밀번호',
                child: CustomFormBuilderTextField(
                  name: 'password',
                  obscureText: true,
                  hintText: '비밀번호를 입력하세요.',
                  helperText: widget.isPasswordVerified ? '좋은 비밀번호네요!' : null,
                  // errorText: formState.verificationStatusOfPassword == AuthVerificationStatus.none ? '비밀번호 설정 규칙에 맞춰 입력해주세요' : null,
                  maxLength: 16,
                  showCounterText: false,
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    FilteringTextInputFormatter.singleLineFormatter,
                    FilteringTextInputFormatter.deny(' ', replacementString: ''),
                  ],
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: '비밀번호를 입력해주세요.'),
                    FormBuilderValidators.match(r"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,20}$", errorText: '비밀번호 설정 규칙에 맞춰 입력해주세요'),
                  ]),
                  onChanged: (value) {
                    if (_passwordConfirmTextEditingController.text.isNotEmpty) {
                      _passwordConfirmTextEditingController.text = '';
                    }
                    widget.onPasswordChanged(value);
                  },
                ),
              ),
              SizedBox(
                height: 40.0.h,
              ),
              CommonLabel(
                label: '비밀번호 확인',
                child: CustomFormBuilderTextField(
                  controller: _passwordConfirmTextEditingController,
                  name: 'passwordConfirm',
                  hintText: '비밀번호 확인',
                  obscureText: true,
                  maxLength: 16,
                  showCounterText: false,
                  keyboardType: TextInputType.text,
                  helperText: widget.isPasswordConfirmVerified != null ? widget.isPasswordConfirmVerified == true ? '확인되었습니다!' : null : null,
                  errorText: widget.isPasswordConfirmVerified != null ? widget.isPasswordConfirmVerified == false ? '비밀번호가 틀렸어요!' : null : null,
                  inputFormatters: [
                    FilteringTextInputFormatter.singleLineFormatter,
                    FilteringTextInputFormatter.deny(' ', replacementString: ''),
                  ],
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: '비밀번호 확인란을 입력해주세요.'),
                  ]),
                  onChanged: (value) => widget.onPasswordConfirmChanged(value),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 60.0.h,
          child: CommonButton(
            isLoading: _isUpdateLoading,
            isActive: !_isUpdateLoading && widget.isPasswordVerified && widget.isPasswordConfirmVerified == true,
            elevation: 0.0,
            fontSize: 16.0.sp,
            fontWeight: FontWeight.w500,
            text: '완료',
            onPressed: () async {
              setState(() {
                _isUpdateLoading = true;
              });

              await widget.onCompleteBtnClicked();

              setState(() {
                _isUpdateLoading = false;
              });
            },
          ),
        ),
      ],
    );
  }
}
