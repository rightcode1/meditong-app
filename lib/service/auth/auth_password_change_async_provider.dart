import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/model/auth/req/auth_req_password_change.dart';
import '../../domain/repository/auth/auth_repository.dart';
import '../../presentation/auth/provider/form/find/auth_find_password_form_provider.dart';

final authPasswordChangeAsyncProvider =
    AsyncNotifierProvider<AuthPasswordChangeAsyncNotifier, AuthReqPasswordChange>(() => AuthPasswordChangeAsyncNotifier());

class AuthPasswordChangeAsyncNotifier extends AsyncNotifier<AuthReqPasswordChange> {
  @override
  FutureOr<AuthReqPasswordChange> build() {
    return AuthReqPasswordChange(loginId: '', password: '', tel: '');
  }

  AuthReqPasswordChange _toModelForLostPassword() {
    final formState = ref.read(authFindPasswordFormProvider);

    return AuthReqPasswordChange.fromJson(formState.toJson());
  }

  Future<Map<String, dynamic>> sendToServerForLostPassword() async {
    try {
      final requestDto = _toModelForLostPassword();
      final response = await ref.read(authRepositoryProvider).passwordChange(body: requestDto);

      return {
        'statusCode': response.statusCode,
        'message': null,
      };
    } catch (err, stack) {
      debugPrint(err.toString());
      debugPrint(stack.toString());

      if (err is DioException) {
        return {
          'statusCode': err.response!.statusCode,
          'message': err.response!.data['message'],
        };
      } else {
        return {
          'statusCode': HttpStatus.internalServerError,
          'message': '예기치 못한 오류 발생'
        };
      }
    }
  }
}
