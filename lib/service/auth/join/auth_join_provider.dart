import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/model/auth/req/join/auth_req_join.dart';
import '../../../domain/repository/auth/auth_repository.dart';
import '../../../presentation/auth/model/form/join/auth_join_form_model.dart';
import '../../../presentation/auth/provider/form/join/auth_join_form_provider.dart';

final authJoinProvider = StateNotifierProvider<AuthJoinStateNotifier, AuthReqJoin>(name: 'authSocialLoginProvider', (ref) {
  final authRepository = ref.watch(authRepositoryProvider);

  return AuthJoinStateNotifier(ref: ref, authRepository: authRepository);
});

/// 회원가입을 위한 Provider
/// 주된 역할은 회원가입 폼인 signUpFormKey 를 Body 로 만들어서 관리하는 역할을 한다.
class AuthJoinStateNotifier extends StateNotifier<AuthReqJoin> {
  final Ref ref;
  final AuthRepository authRepository;

  AuthJoinStateNotifier({
    required this.ref,
    required this.authRepository,
  }) : super(const AuthReqJoin(loginId: '', password: '', name: '', tel: ''));

  /// 현재 회원가입 폼을 모델로 변환한다.
  Future<void> toModel() async {
    AuthJoinFormModel formState = ref.read(authJoinFormProvider);

    state = AuthReqJoin.fromJson(formState.formData);
  }

  /// 현재 관리되고 있는 모델을 서버로 전송시켜 회원가입시킨다..
  Future<bool> join() async {
    try {
      await toModel();
      final response = await authRepository.join(body: state);

      if (response.statusCode == HttpStatus.ok) {
        debugPrint('회원가입에 성공하였습니다. message=${response.message}');
        return true;
      } else {
        throw Exception('정의되지 않은 상태코드입니다. statusCode=${response.statusCode}');
      }
    } catch (err, stack) {
      if (err is DioException && err.response?.statusCode == HttpStatus.badRequest) {
        debugPrint('회원가입에 실패했습니다. message=${err.response?.data['message']}');
        throw Exception('회원가입에 실패했습니다. message=${err.response?.data['message']}');
      } else {
        debugPrint(stack.toString());
        throw Exception('예상치 못한 오류가 발생했습니다. 로그를 확인해주세요.');
      }
    }
  }
}
