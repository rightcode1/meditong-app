import 'package:meditong/core/component/label/common_label.dart';
import 'package:meditong/core/component/text_fields/custom_form_builder_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        CommonLabel(
          label: '이메일',
          child: CustomFormBuilderTextField(
            name: 'loginId',
            hintText: '이메일을 입력해주세요.',
            onChanged: onLoginIdChanged,
          ),
        ),
        SizedBox(
          height: 16.5.h,
        ),
        CommonLabel(
          label: '비밀번호',
          child: CustomFormBuilderTextField(
            name: 'password',
            hintText: '비밀번호를 입력해주세요.',
            onChanged: onPasswordChanged,
          ),
        ),
      ],
    );
  }
}
