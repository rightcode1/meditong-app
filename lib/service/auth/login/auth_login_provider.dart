import 'dart:io';

import 'package:meditong/core/exception/request_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meditong/core/constant/data.dart';
import 'package:meditong/core/provider/secure_storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/model/auth/req/login/auth_req_login.dart';
import '../../../domain/repository/auth/auth_repository.dart';
import '../../../presentation/auth/provider/form/login/auth_login_form_provider.dart';
import '../../user/provider/user_providers.dart';

part 'auth_login_provider.g.dart';

@riverpod
Future<bool> authLogin(AuthLoginRef ref) async {
  try {
    final formState = ref.read(authLoginFormProvider);
    final requestDto = AuthReqLogin.fromJson(formState.toJson());
    final response = await ref.read(authRepositoryProvider).login(body: requestDto);

    if (response.statusCode == HttpStatus.ok) {
      debugPrint('로그인에 성공하였습니다. message=${response.message}');
      await ref.read(secureStorageProvider).write(key: ACCESS_TOKEN_KEY, value: response.token);
      await ref.read(userInfoProvider.notifier).getInfo();

      // TODO: FCM 사용 시 주석 해제하여 사용
      // // 서버로 FCM 토큰을 등록한다.
      // final user = ref.read(userInfoProvider);
      // if (user is UserRes) {
      //   ref.read(firebaseUtilsProvider.notifier).registerFcmTokenToServer(userId: user.id);
      // }

      return true;
    } else {
      throw Exception('정의되지 않은 상태코드입니다. statusCode=${response.statusCode}');
    }
  } on DioException catch (err, stack) {
    debugPrint(err.toString());
    debugPrint(stack.toString());

    return false;
  } catch (err) {
    throw RequestException(message: err.toString());
  }
}