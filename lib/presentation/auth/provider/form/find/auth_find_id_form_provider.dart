
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../enum/auth_enum.dart';
import '../../../model/form/find/auth_find_id_form.dart';

final authFindIdFormProvider = NotifierProvider.autoDispose<AuthFindIdFormNotifier, AuthFindIdForm>(() => AuthFindIdFormNotifier());

class AuthFindIdFormNotifier extends AutoDisposeNotifier<AuthFindIdForm> {
  @override
  AuthFindIdForm build() {
    return AuthFindIdForm();
  }

  /// 휴대 번호를 변경한다.
  void changeTel(String tel) {
    state = state.copyWith(
      tel: tel,
    );

    debugPrint(state.toString());
  }

  /// 인증번호를 변경한다.
  void changeVerificationNumber(String verificationNumber) {
    state = state.copyWith(
      verificationNumber: verificationNumber,
    );

    debugPrint(state.toString());
  }

  /// 휴대전화 인증 상태를 변경한다.
  void changeVerificationNumberStatus(AuthVerificationNumberStatus status) {
    state = state.copyWith(
      verificationNumberStatus: status,
    );

    debugPrint(state.toString());
  }
}