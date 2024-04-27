import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediport/core/component/text_fields/common_form_text_field.dart';

/// 로그인 기본 폼, 형태에 맞게 재정의하여 사용한다.
class AuthLoginFormColumn extends ConsumerWidget {
  const AuthLoginFormColumn({
    Key? key,
    required this.onLoginIdChanged,
    required this.onPasswordChanged,
  }) : super(key: key);

  final Function(String? loginId) onLoginIdChanged;
  final Function(String? password) onPasswordChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CommonForm.create(
          name: 'loginId',
          hintText: '이메일을 입력해주세요.',
          onChanged: (controller) => onLoginIdChanged(controller.text),
        ),
        SizedBox(
          height: 20.0.h,
        ),
        CommonForm.create(
          name: 'password',
          hintText: '비밀번호를 입력해주세요.',
          obscureText: true,
          onChanged: (controller) => onPasswordChanged(controller.text),
        ),
      ],
    );
  }
}
