import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repository/auth/auth_repository.dart';
import '../../presentation/auth/enum/auth_enum.dart';

final authCertProvider = AsyncNotifierProvider.autoDispose<AuthCertNotifier, void>(() => AuthCertNotifier());

/// 인증과 관련한 유틸성 비즈니스 로직을 관리하는 프로바이더
class AuthCertNotifier extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<void> sendVerificationCode({
    required String tel,
    required AuthDiff diff,
    required Function(AuthVerificationNumberStatus status) onSending,
    required Function(AuthVerificationNumberStatus status) onSent,
    required Function(AuthVerificationNumberStatus status) onAlreadyExistsError,
    required Function(AuthVerificationNumberStatus status) onTooManyRequestsError,
    required Function(AuthVerificationNumberStatus status) onInvalidFormatError,
    required Function(AuthVerificationNumberStatus status) onUnknownError,
  }) async {
    final authRepository = ref.read(authRepositoryProvider);

    onSending(AuthVerificationNumberStatus.sending);

    try {
      final response = await authRepository.certificationNumberSMS(tel: tel, diff: diff);
      if (response.statusCode == HttpStatus.ok) {
        debugPrint('인증번호 전송에 성공하였습니다.');
        onSent(AuthVerificationNumberStatus.sent);
      } else if (response.statusCode == HttpStatus.accepted) {
        debugPrint('이미 존재하는 휴대번호입니다.');
        onAlreadyExistsError(AuthVerificationNumberStatus.failed);
      } else {
        throw Exception('정의되지 않은 상태코드입니다. statusCode=${response.statusCode}');
      }
    } catch (err, stack) {
      if (err is DioException && err.response?.statusCode == HttpStatus.tooManyRequests) {
        onTooManyRequestsError(AuthVerificationNumberStatus.failed);
      } else if (err is DioException && err.response?.statusCode == HttpStatus.badRequest) {
        debugPrint('휴대폰 인증에 실패하였습니다. message=${err.response?.data['message']}');
        onInvalidFormatError(AuthVerificationNumberStatus.failed);
      } else {
        debugPrint('예기치 못한 오류가 발생했습니다.');
        debugPrint(err.toString());
        debugPrint(stack.toString());
        onUnknownError(AuthVerificationNumberStatus.failed);
      }
    }
  }

  /// 인증번호를 서버로 전송하여 검증한다.
  Future<void> verifyNumber({
    required String tel,
    required String verificationNumber,
    required Function(AuthVerificationNumberStatus status) onSucceed,
    required Function(AuthVerificationNumberStatus status) onFailed,
    required Function(AuthVerificationNumberStatus status) onUnknownError,
  }) async {
    try {
      final response = await ref.read(authRepositoryProvider).confirm(tel: tel, confirm: verificationNumber);

      // 상태 코드가 200일 경우 인증 완료, 400일 경우 인증 실패를 의미한다. (400 코드는 catch 를 통해 잡힌다.)
      if (response.statusCode == HttpStatus.ok) {
        debugPrint('인증에 성공하였습니다. message=${response.message}');
        onSucceed(AuthVerificationNumberStatus.confirmed);
      } else {
        throw Exception('정의되지 않은 상태코드입니다. statusCode=${response.statusCode}, message=${response.message}');
      }
    } catch (err, stack) {
      // Dio 를 통해 반환된 에러이면서, BadRequest 상태인 경우 Known Exception 이므로 인증에 실패한 상태로 변경한다.
      if (err is DioException && err.response?.statusCode == HttpStatus.badRequest) {
        debugPrint('인증에 실패하였습니다. message=${err.message}');
        onFailed(AuthVerificationNumberStatus.invalid);
      } else {
        debugPrint(err.toString());
        debugPrint(stack.toString());
        onUnknownError(AuthVerificationNumberStatus.failed);
      }
    }
  }

  /// 사용가능한 비밀번호인지 정규식을 통해 체크한다.
  void checkAvailablePassword({
    required String password,
    required Function(AuthVerificationStatus status) onSucceed,
    required Function(AuthVerificationStatus status) onFailed,
  }) {
    final passwordRegExp = RegExp(r"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,20}$");

    if (passwordRegExp.hasMatch(password)) {
      onSucceed(AuthVerificationStatus.verified);
    } else {
      onFailed(AuthVerificationStatus.unverified);
    }
  }

  /// "비밀번호 확인" 시, 기존에 입력한 비밀번호와 일치하는지 확인한다.
  void checkIfPasswordConfirmEqualToPassword({
    required password,
    required passwordConfirm,
    required Function(AuthVerificationStatus status) onSucceed,
    required Function(AuthVerificationStatus status) onFailed,
  }) {
    if (password == passwordConfirm) {
      onSucceed(AuthVerificationStatus.verified);
    } else {
      onFailed(AuthVerificationStatus.unverified);
    }
  }
}
