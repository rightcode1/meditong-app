import 'package:json_annotation/json_annotation.dart';

part 'auth_req_login.g.dart';

/// 로그인 Request DTO
@JsonSerializable()
class AuthReqLogin {
  /// 로그인 아이디
  final String loginId;

  /// 패스워드
  final String password;

  AuthReqLogin({
    required this.loginId,
    required this.password,
  });

  factory AuthReqLogin.fromJson(Map<String, dynamic> json) => _$AuthReqLoginFromJson(json);

  Map<String, dynamic> toJson() => _$AuthReqLoginToJson(this);
}
