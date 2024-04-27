import 'package:json_annotation/json_annotation.dart';

part 'auth_req_social_login.g.dart';

@JsonSerializable(includeIfNull: false)
class AuthReqSocialLogin {
  /// 소셜 고유 번호
  final String? loginId;
  /// 비밀번호 (정해진 비밀 키)
  final String? password;
  /// 로그인 정보 (kakao, apple, facebook 등)
  final String? provider;
  /// 권한
  final String? role;
  /// 휴대번호
  final String? tel;
  /// 실명
  final String? name;
  /// 소속
  final String? company;

  AuthReqSocialLogin({
    required this.loginId,
    required this.password,
    required this.provider,
    this.role,
    this.tel,
    this.name,
    this.company,
  });

  AuthReqSocialLogin copyWith({
    String? loginId,
    String? password,
    String? provider,

  }) {
    return AuthReqSocialLogin(loginId: loginId, password: password, provider: provider,);
}

  factory AuthReqSocialLogin.fromJson(Map<String, dynamic> json)
  => _$AuthReqSocialLoginFromJson(json);

  Map<String, dynamic> toJson() => _$AuthReqSocialLoginToJson(this);

  @override
  String toString() {
    return 'AuthReqSocialLogin{loginId: $loginId, password: $password, provider: $provider, role: $role, tel: $tel, name: $name, company: $company}';
  }
}