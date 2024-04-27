import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditong/core/constant/data.dart';
import 'package:meditong/core/provider/secure_storage_provider.dart';

import '../../../core/util/sns/impl/auth_sign_in_apple.dart';
import '../../../core/util/sns/impl/auth_sign_in_kakao.dart';
import '../../../core/util/sns/impl/auth_sign_in_naver.dart';
import '../../../domain/model/auth/req/login/auth_req_social_login.dart';
import '../../../domain/repository/auth/auth_repository.dart';
import '../../../presentation/auth/enum/auth_enum.dart';
import '../../../presentation/auth/provider/form/join/auth_join_form_provider.dart';
import '../../user/provider/user_providers.dart';

final authSocialLoginProvider = StateNotifierProvider<AuthSocialLoginStateNotifier, AuthReqSocialLogin>(name: 'authSocialLoginProvider', (ref) {
  final authRepository = ref.watch(authRepositoryProvider);

  return AuthSocialLoginStateNotifier(ref: ref, authRepository: authRepository);
});

/// Auth API 에서 소셜 로그인을 수행하기 위한 모델을 관리하는 Provider
/// 주된 역할은 회원가입 폼인 signUpFormKey 를 Body 로 만들어서 관리하는 역할을 한다.
class AuthSocialLoginStateNotifier extends StateNotifier<AuthReqSocialLogin> {
  final Ref ref;
  final AuthRepository authRepository;

  AuthSocialLoginStateNotifier({
    required this.ref,
    required this.authRepository,
  }) : super(AuthReqSocialLogin(loginId: '', password: '', provider: null));

  /// 현재 회원가입 폼을 모델로 변환한다.
  Future<void> toModel() async {
    final formState = ref.read(authJoinFormProvider);
    print(formState.formData);

    state = AuthReqSocialLogin.fromJson(formState.formData);
  }

  /// 현재 관리되고 있는 모델을 서버로 전송시켜 회원가입시킨다.
  ///
  /// 만일, 카카오 로그인일 경우 현재 유저의 프로필 사진을 기본 프로필 이미지로 변경한다.
  Future<bool> signUp() async {
    try {
      await toModel();
      final response = await authRepository.socialLogin(body: state);

      if (response.statusCode == HttpStatus.ok) {
        debugPrint('회원가입에 성공하였습니다. message=${response.message}');

        // 회원가입 직후, 토큰을 storage 에 저장한다.
        final token = response.token;
        await ref.read(secureStorageProvider).write(key: ACCESS_TOKEN_KEY, value: token);

        return true;
      } else {
        throw Exception('정의되지 않은 상태코드입니다. statusCode=${response.statusCode}');
      }
    } catch (err, stack) {
      if (err is DioException && err.response?.statusCode == HttpStatus.badRequest) {
        debugPrint('회원가입에 실패했습니다. message=${err.response?.data['message']}');
        throw Exception('회원가입에 실패했습니다. message=${err.response?.data['message']}');
      } else {
        debugPrint(err.toString());
        debugPrint(stack.toString());
        throw Exception('예상치 못한 오류가 발생했습니다. 로그를 확인해주세요.');
      }
    }
  }

  /// SNS 계정을 통해 로그인을 시도한다.
  ///
  /// [loginId] 와 [snsProvider] 를 전달받아 모델 초기화 후 서버로 전송한다.
  /// 상태코드가 200 일 경우, 서버에 존재하는 사용자이므로 로그인시킨다.
  /// 상태코드가 203 일 경우, 신규 사용자를 의미한다.
  ///
  /// true 가 리턴될 경우, 기존재하는 사용자이므로 로그인된다.
  /// false 가 리턴될 경우, 존재하지 않는 사용자이므로 회원가입을 시켜야한다.
  Future<bool> signIn({required AuthSnsProvider snsProvider}) async {
    try {
      late final String identifier;

      // 전달받은 snsProvider 에 따라 조건을 분기하여 로그인을 시도하고, identifier 를 가져온다.
      if (snsProvider == AuthSnsProvider.kakao) {
        // 카카오로 로그인을 시도한다.
        await AuthSignInKakao().signIn();

        // 로그인되었다면, 카카오에서 유저에 대한 고유 아이디를 가져온다.
        identifier = await AuthSignInKakao().getIdentifier();
      } else if (snsProvider == AuthSnsProvider.naver) {
        await AuthSignInNaver().signIn();

        identifier = await AuthSignInNaver().getIdentifier();
      } else if (snsProvider == AuthSnsProvider.apple) {
        identifier = await AuthSignInApple().getIdentifier();
      } else {
        throw Exception('정의되지 않은 SNS 로그인 방식입니다. snsProvider=${snsProvider}');
      }

      // 전달받은 파라미터를 통해 상태를 초기화한다.
      state = state.copyWith(
        loginId: identifier,
        provider: snsProvider.name,
        password: 'rightcode1234',
      );

      final response = await authRepository.socialLogin(body: state);

      if (response.statusCode == HttpStatus.ok) {
        debugPrint('기존재하는 회원입니다. 로그인합니다.');
        await ref.read(secureStorageProvider).write(key: ACCESS_TOKEN_KEY, value: response.token);
        await ref.read(userInfoProvider.notifier).getInfo();

        // TODO: FCM 사용 시 주석 해제하여 사용
        // // 서버로 FCM 토큰을 등록한다.
        // final user = ref.read(userInfoProvider);
        // if (user is UserRes) {
        //   ref.read(firebaseUtilsProvider.notifier).registerFcmTokenToServer(userId: user.id);
        // }

        return true;
      } else if (response.statusCode == HttpStatus.nonAuthoritativeInformation) {
        debugPrint('존재하지 않는 회원입니다. 회원가입합니다.');
        return false;
      } else {
        throw Exception('정의되지 않은 상태코드입니다. statusCode=${response.statusCode}');
      }
    } catch (err, stack) {
      if (err is DioException) {
        debugPrint(err.toString());
        debugPrint(stack.toString());

        throw Exception('API 오류가 발생했습니다. 로그를 확인해주세요.');
      } else {
        debugPrint(err.toString());
        debugPrint(stack.toString());

        throw Exception('예상치 못한 오류가 발생했습니다. 로그를 확인해주세요.');
      }
    }
  }

  /// 회원가입 이후 즉시 로그인을 시키기 위한 로직
  Future<bool> signInAfterSignUp(String snsProvider, String identifier) async {
    try {
      // 전달받은 파라미터를 통해 상태를 초기화한다.
      state = state.copyWith(
        loginId: identifier,
        provider: snsProvider,
        password: 'rightcode1234',
      );

      final response = await authRepository.socialLogin(body: state);

      if (response.statusCode == HttpStatus.ok) {
        debugPrint('기존재하는 회원입니다. 로그인합니다.');
        await ref.read(secureStorageProvider).write(key: ACCESS_TOKEN_KEY, value: response.token);
        await ref.read(userInfoProvider.notifier).getInfo();

        final userInfo = ref.read(userInfoProvider);

        // TODO: FCM 사용 시 주석 해제하여 사용
        // // 서버로 FCM 토큰을 등록한다.
        // final user = ref.read(userInfoProvider);
        // if (user is UserRes) {
        //   ref.read(firebaseUtilsProvider.notifier).registerFcmTokenToServer(userId: user.id);
        // }

        return true;
      } else if (response.statusCode == HttpStatus.nonAuthoritativeInformation) {
        debugPrint('존재하지 않는 회원입니다. 회원가입합니다.');
        return false;
      } else {
        throw Exception('정의되지 않은 상태코드입니다. statusCode=${response.statusCode}');
      }
    } catch (err, stack) {
      if (err is DioException) {
        debugPrint(err.toString());
        debugPrint(stack.toString());

        throw Exception('오류가 발생했습니다. 로그를 확인해주세요.');
      } else {
        debugPrint(err.toString());
        debugPrint(stack.toString());

        throw Exception('예기치 못한 발생했습니다. 로그를 확인해주세요.');
      }
    }
  }
}
