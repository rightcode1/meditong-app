import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../model/form/login/auth_login_form_model.dart';

part 'auth_login_form_provider.g.dart';

@riverpod
class AuthLoginForm extends _$AuthLoginForm {
  @override
  AuthLoginFormModel build() {
    return const AuthLoginFormModel();
  }

  /// 아이디를 변경한다.
  void changeLoginId(String loginId) {
    state = state.copyWith(loginId: loginId);

    debugPrint(state.toString());
  }

  /// 비밀번호를 변경한다.
  void changePassword(String password) {
    state = state.copyWith(password: password);

    debugPrint(state.toString());
  }
}
