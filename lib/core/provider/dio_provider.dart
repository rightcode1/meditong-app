import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meditong/core/provider/secure_storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constant/data.dart';

/// dio Provider 및 인터셉터 콘피그
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  dio.interceptors.add(
    CustomInterceptor(
      // storage: storage,
      ref: ref,
    ),
  );

  return dio;
});

/// DIO 인터셉터
class CustomInterceptor extends Interceptor {
  final Ref ref;

  CustomInterceptor({
    required this.ref,
  });

  // 1) 요청을 보낼때
  // 요청이 보내질때마다
  // 만약에 요청의 Header에 accessToken: true라는 값이 있다면
  // 실제 토큰을 가져와서 (storage에서) authorization: bearer $token으로
  // 헤더를 변경한다.
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    debugPrint('[REQ] [${options.method}] ${options.uri}');

    // token 이 없을때
    if (options.headers['authorization'] == 'true') {
      final token = await ref.read(secureStorageProvider).read(key: ACCESS_TOKEN_KEY);
      // API 명세서에서 API 호출 시 토큰 값을 바로 넣을 수 있게 하기 위한 임시 디버깅용 프린트 (필요에 따라 제거해도 된다.)
      debugPrint(token);

      options.headers.remove('authorization');
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    return super.onRequest(options, handler);
  }

  // 2) 응답을 받을때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}');

    return super.onResponse(response, handler);
  }

  // 3) 에러가 났을때
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401에러가 났을때 (status code)
    // 토큰을 재발급 받는 시도를하고 토큰이 재발급되면
    // 다시 새로운 토큰으로 요청을한다.
    debugPrint('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}\n [SERVER ERROR RESPONSE]: ${err.response}');
    debugPrint(err.toString());

    final isStatus401 = err.response?.statusCode == HttpStatus.unauthorized;

    if (isStatus401) {
      debugPrint('API 요청을 시도하였으나, 토큰이 없어 요청이 실패되었습니다.');

      return handler.reject(err);
    }

    // 이용이 제한 되었을 경우에 대한 조건문 처리, String 으로 처리하면 안 되지만, 상황에 따라서 적절히 변형하여 활용한다. 필요 없을 경우 제거한다.
    if (err.response?.data['message'] == '이용이 제한되었습니다.') {
      // TODO: userLogOutProvider 호출하여 유저 로그아웃 시키기
      return handler.reject(err);
    }

    return handler.reject(err);
  }
}
