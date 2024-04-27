import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../enum/auth_enum.dart';
import '../../../model/form/find/auth_find_password_form.dart';

final authFindPasswordFormProvider = NotifierProvider.autoDispose<AuthFindPasswordFormNotifier, AuthFindPasswordForm>(() => AuthFindPasswordFormNotifier());

class AuthFindPasswordFormNotifier extends AutoDisposeNotifier<AuthFindPasswordForm> {
  @override
  AuthFindPasswordForm build() {
    return AuthFindPasswordForm();
  }

  /// 아이디를 변경한다.
  void changeLoginId(String loginId) {
    state = state.copyWith(
      loginId: loginId,
    );

    debugPrint(state.toString());
  }

  /// 휴대 번호를 변경한다.
  void changeTel(String tel) {
    state = state.copyWith(
      tel: tel,
    );

    debugPrint(state.toString());
  }

  /// 비밀번호를 변경한다.
  void changePassword(String password) {
    state = state.copyWith(
      password: password,
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

  /// 비밀번호 사용 가능 상태를 변경한다.
  void changeVerificationStatusOfPassword(AuthVerificationStatus status) {
    state = state.copyWith(
      verificationStatusOfPassword: status,
    );

    debugPrint(state.toString());
  }

  /// 비밀번호 일치 여부 상태를 변경한다.
  void changeVerificationStatusOfPasswordConfirm(AuthVerificationStatus status) {
    state = state.copyWith(
      verificationStatusOfPasswordConfirm: status,
    );

    debugPrint(state.toString());
  }

  /*
    리셋 메소드
   */
  /// 비밀번호를 초기화한다.
  void resetPassword() {
    state = state.copyWith(
      password: '-1',
    );

    debugPrint(state.toString());
  }

  /// 비밀번호 인증 상태를 초기화한다.
  void resetVerificationStatusOfPassword() {
    state = state.copyWith(
      verificationStatusOfPassword: AuthVerificationStatus.none,
    );

    debugPrint(state.toString());
  }

  /// 비밀번호 확인 상태를 초기화한다.
  void resetVerificationStatusOfPasswordConfirm() {
    state = state.copyWith(
      verificationStatusOfPasswordConfirm: AuthVerificationStatus.none,
    );

    debugPrint(state.toString());
  }
}