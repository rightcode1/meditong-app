import 'package:meditong/core/extension/string_extentions.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_login_form_model.g.dart';

/// 로그인을 위한 API 를 서버로 요청하기 위해 사용되는 Form Model
@JsonSerializable()
class AuthLoginFormModel {
  final String? loginId;
  final String? password;

  bool get isAllValidated {
    final validLoginId = loginId != null && loginId!.isNotEmpty && loginId!.validateEmail();
    final validPassword = password != null && password!.isNotEmpty;

    return validLoginId && validPassword;
  }

  const AuthLoginFormModel({
    this.loginId,
    this.password,
  });

  AuthLoginFormModel copyWith({
    String? loginId,
    String? password,
  }) {
    return AuthLoginFormModel(
      loginId: loginId ?? this.loginId,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toJson() => _$AuthLoginFormModelToJson(this);

  @override
  String toString() {
    return 'AuthLoginFormModel{loginId: $loginId, password: $password}';
  }
}
