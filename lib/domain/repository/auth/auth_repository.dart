import 'package:meditong/core/constant/data.dart';
import 'package:meditong/core/provider/dio_provider.dart';
import 'package:meditong/domain/model/auth/req/auth_req_password_change.dart';
import 'package:meditong/domain/model/auth/req/join/auth_req_join.dart';
import 'package:meditong/domain/model/auth/req/login/auth_req_login.dart';
import 'package:meditong/domain/model/auth/req/login/auth_req_social_login.dart';
import 'package:meditong/domain/model/base_res.dart';
import 'package:meditong/presentation/auth/enum/auth_enum.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) => AuthRepository(ref.watch(dioProvider), baseUrl: '$baseHostV1/auth');

@RestApi()
abstract class AuthRepository {
  factory AuthRepository(Dio dio, {String baseUrl}) = _AuthRepository;

  /// 회원가입
  @POST('/join')
  Future<BaseResponse> join({
    @Body() required AuthReqJoin body,
  });

  @POST('/login')
  Future<BaseResponse> login({
    @Body() required AuthReqLogin body,
  });

  @POST('/social/login')
  Future<BaseResponse> socialLogin({
    @Body() required AuthReqSocialLogin body,
  });

  /// 아이디 중복 체크
  @GET('/existLoginId')
  Future<BaseResponse> existLoginId({
    @Query('loginId') required String loginId,
  });

  /// 핸드폰 인증 번호 발송
  @GET('/certificationNumberSMS')
  Future<BaseResponse> certificationNumberSMS({
    /// 핸드폰 번호
    @Query('tel') required String tel,

    /// 구분 ("join", "find", "update")
    @Query('diff') required AuthDiff diff,
  });

  /// 인증하기
  @GET('/confirm')
  Future<BaseResponse> confirm({
    /// 핸드폰 번호
    @Query('tel') required String tel,

    /// 인증번호
    @Query('confirm') required String confirm,
  });

  /// 아이디 찾기
  @GET('/findLoginId')
  Future<BaseResponse<dynamic>> findLoginId({
    @Query('tel') required String tel,
  });

  /// 비밀번호 변경
  @POST('/passwordChange')
  Future<BaseResponse> passwordChange({
    @Body() required AuthReqPasswordChange body,
  });
}
