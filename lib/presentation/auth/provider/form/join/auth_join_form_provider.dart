import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediport/core/extension/string_extentions.dart';

import '../../../../../domain/repository/auth/auth_repository.dart';
import '../../../enum/auth_enum.dart';
import '../../../model/form/join/auth_join_form_model.dart';

final authJoinFormProvider = StateNotifierProvider.autoDispose<AuthSignUpFormStateNotifier, AuthJoinFormModel>(
  name: 'authJoinFormProvider',
  (ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    return AuthSignUpFormStateNotifier(authRepository: authRepository);
  },
);

class AuthSignUpFormStateNotifier extends StateNotifier<AuthJoinFormModel> {
  final AuthRepository authRepository;

  AuthSignUpFormStateNotifier({
    required this.authRepository,
  }) : super(AuthJoinFormModel());

  /// 폼 상태를 변경한다.
  void changeState({
    String? loginId,
    String? password,
    String? passwordConfirm,
    String? name,
    String? tel,
    String? telVerificationCode,
}) {
    state = state.copyWith(
      loginId: loginId,
      password: password,
      passwordConfirm: passwordConfirm,
      name: name,
      tel: tel,
      telVerificationCode: telVerificationCode,
    );
}

  /// 아이디 검증이 완료되었을 경우, 완료 상태로 변경한다.
  void completeLoginIdVerified() {
    state = state.copyWith(isLoginIdVerified: AuthVerificationStatus.verified);
  }

  /// 아이디가 유효하지 않을 경우, 사용가능한 아이디 여부를 인증 실패 상태로 변경한다.
  void incompleteLoginIdVerified() {
    state = state.copyWith(isLoginIdVerified: AuthVerificationStatus.unverified);
  }

  /// 아이디의 검증 상태를 초기 상태로 변경한다.
  void resetLoginIdVerified() {
    state = state.copyWith(
      isLoginIdVerified: AuthVerificationStatus.none,
    );
  }

  /// 비밀번호 검증이 완료되었을 경우, 완료 상태로 변경한다.
  void completePasswordVerified() {
    state = state.copyWith(isPasswordVerified: AuthVerificationStatus.verified);
  }

  /// 비밀번호가 유효하지 않을 경우, 사용가능한 비밀번호 여부를 인증 실패 상태로 변경한다.
  void incompletePasswordVerified() {
    state = state.copyWith(isPasswordVerified: AuthVerificationStatus.unverified);
  }

  /// 비밀번호의 검증 상태를 초기 상태로 변경한다.
  void resetPasswordVerified() {
    state = state.copyWith(
      isPasswordVerified: AuthVerificationStatus.none,
    );
  }

  /// 비밀번호 확인 검증이 완료되었을 경우, 완료 상태로 변경한다.
  void completePasswordConfirmVerified() {
    state = state.copyWith(isPasswordConfirmVerified: AuthVerificationStatus.verified);
  }

  /// 비밀번호 확인이 유효하지 않을 경우, 비밀번호 확인 여부를 인증 실패 상태로 변경한다.
  void incompletePasswordConfirmVerified() {
    state = state.copyWith(isPasswordConfirmVerified: AuthVerificationStatus.unverified);
  }

  /// 비밀번호 확인의 검증 상태를 초기 상태로 변경한다.
  void resetPasswordConfirmVerified() {
    state = state.copyWith(
      isPasswordConfirmVerified: AuthVerificationStatus.none,
    );
  }

  /// 인증번호 인증 여부에 대한 상태를 변경한다.
  void changeVerificationNumberStatus(AuthVerificationNumberStatus verificationNumberStatus) {
    state = state.copyWith(verificationNumberStatus: verificationNumberStatus);
  }

//////////////////////////////////////////////////////////////////
// 비즈니스 로직
////////////////////////////////////////////////////////////////////

  /// 사용할 수 있는 로그인 아이디인지 Debouncer 를 적용하여 체크한다.
  Future<void> checkAvailableLoginId(String loginId) async {
    changeState(loginId: loginId);
    // 공백일 경우, 기존에 모든 Debounce 요청을 취소한다.
    if (loginId.isEmpty) {
      resetLoginIdVerified();
      EasyDebounce.cancel('existsLoginId');

      return;
    }

    // 정규식을 체크한다. 일치하지 않을 경우 모든 Debounce 요청을 취소한다.
    if (!loginId.validateEmail()) {
      // debugPrint('아이디 정규식이 올바르지 않습니다.');
      resetLoginIdVerified();
      EasyDebounce.cancel('existsLoginId');

      return;
    }

    EasyDebounce.debounce('existsLoginId', const Duration(milliseconds: 500), () async {
      try {
        final response = await authRepository.existLoginId(loginId: loginId);

        if (response.statusCode == HttpStatus.ok) {
          debugPrint('사용가능한 아이디입니다. loginId=$loginId');
          completeLoginIdVerified();
        } else if (response.statusCode == HttpStatus.accepted) {
          incompleteLoginIdVerified();
        } else {
          resetLoginIdVerified();
          throw Exception('정의되지 않은 상태코드입니다. statusCode=${response.statusCode}, message=${response.message}');
        }
      } catch (err, stack) {
        if (err is DioException && err.response?.statusCode == HttpStatus.badRequest) {
          // debugPrint('사용할 수 없는 아이디입니다. loginId=$loginId');
          incompleteLoginIdVerified();
        } else {
          debugPrint(err.toString());
          debugPrint(stack.toString());
          resetLoginIdVerified();
          throw Exception('시스템 오류입니다. 스택을 확인해주세요.');
        }
      }
    });

    // // 만일, 이전 닉네임과 새로운 닉네임이 다를 경우, Debouncer 를 동작시켜 닉네임 사용 여부를 검사한다.
    // if ((pLoginId != loginId)) {
    // }
  }

  /// 사용가능한 비밀번호인지, 비밀번호가 일치한지 정규식을 통해 체크한다.
  void checkAvailablePassword(String? pPassword, String password) {
    changeState(password: password);
    if (password.isEmpty) {
      // debugPrint('비밀번호가 비어있습니다. 모든 상태를 초기화시킵니다.');
      resetPasswordVerified();
      return;
    }
    final passwordRegExp = RegExp(r"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,20}$");

    if (pPassword != password) {
      resetPasswordConfirmVerified();
      checkPasswordConfirmEqualToPassword(state.passwordConfirm);
      if (passwordRegExp.hasMatch(password)) {
        debugPrint('사용가능한 비밀번호입니다.');
        completePasswordVerified();
        return;
      } else {
        // debugPrint('사용할 수 없는 비밀번호입니다.');
        incompletePasswordVerified();
        return;
      }
    }
  }

  /// 현재 비밀번호와 일치하는지 체크한다.
  void checkPasswordConfirmEqualToPassword(String passwordConfirm) {
    changeState(passwordConfirm: passwordConfirm);
    final String password = state.password;

    if (passwordConfirm.isEmpty) {
      // debugPrint('비밀번호 확인 란이 비어있습니다.');
      resetPasswordConfirmVerified();

      return;
    }

    if (passwordConfirm == password) {
      debugPrint('비밀번호가 일치합니다.');
      completePasswordConfirmVerified();
      return;
    } else {
      // debugPrint('비밀번호가 일치하지 않습니다.');
      incompletePasswordConfirmVerified();
      return;
    }
  }

  /// 휴대폰 인증 번호를 발송한다.
  /// 만일, 현재 입력한 휴대폰 번호가 이미 서버에 등록되어있는 값일 경우, 예외를 발생시키고 팝업창을 띄울 수 있는 상태로 변경한다.
  Future<void> sendVerificationNumber() async {
    changeVerificationNumberStatus(AuthVerificationNumberStatus.sending);

    try {
      final tel = state.tel;
      final response = await authRepository.certificationNumberSMS(tel: tel, diff: AuthDiff.join);

      if (response.statusCode == HttpStatus.ok) {
        debugPrint('인증번호 전송에 성공하였습니다.');
        changeVerificationNumberStatus(AuthVerificationNumberStatus.sent);
      } else if (response.statusCode == HttpStatus.accepted) {
        debugPrint('이미 존재하는 휴대번호입니다.');
        changeVerificationNumberStatus(AuthVerificationNumberStatus.failed);
      } else {
        throw Exception('정의되지 않은 상태코드입니다. statusCode=${response.statusCode}');
      }
    } catch (err) {
      if (err is DioException && err.response?.statusCode == HttpStatus.tooManyRequests) {
        changeVerificationNumberStatus(AuthVerificationNumberStatus.failed);
      }

      if (err is DioException && err.response?.statusCode == HttpStatus.badRequest) {
        debugPrint('휴대폰 인증에 실패하였습니다. message=${err.response?.data['message']}');
        changeVerificationNumberStatus(AuthVerificationNumberStatus.failed);
      }
    }
  }

  /// 유저가 입력한 인증번호를 통해 올바른 인증코드인지 체크한다.
  Future<bool> checkVerificationNumber() async {
    final tel = state.tel;
    final verificationNumber = state.telVerificationCode;

    try {
      final response = await authRepository.confirm(tel: tel, confirm: verificationNumber);

      // 상태 코드가 200일 경우 인증 완료, 400일 경우 인증 실패를 의미한다. (400 코드는 catch 를 통해 잡힌다.)
      if (response.statusCode == HttpStatus.ok) {
        debugPrint('인증에 성공하였습니다. message=${response.message}');
        changeVerificationNumberStatus(AuthVerificationNumberStatus.confirmed);
        return true;
      } else {
        throw Exception('정의되지 않은 상태코드입니다. statusCode=${response.statusCode}, message=${response.message}');
      }
    } catch (err, stack) {
      // Dio 를 통해 반환된 에러이면서, BadRequest 상태인 경우 Known Exception 이므로 인증에 실패한 상태로 변경한다.
      if (err is DioException && err.response?.statusCode == HttpStatus.badRequest) {
        debugPrint('인증에 실패하였습니다. message=${err.message}');
        changeVerificationNumberStatus(AuthVerificationNumberStatus.invalid);
        return false;
      } else {
        debugPrint(stack.toString());
        throw Exception('시스템 오류입니다. 스택을 확인해주세요.');
      }
    }
  }
}
