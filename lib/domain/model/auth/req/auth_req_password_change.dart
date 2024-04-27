import 'package:json_annotation/json_annotation.dart';

part 'auth_req_password_change.g.dart';

@JsonSerializable(includeIfNull: false)
class AuthReqPasswordChange {
  final String? loginId;
  final String password;
  final String? tel;

  AuthReqPasswordChange({
    this.loginId,
    required this.password,
    this.tel,
  });

  Map<String, dynamic> toJson() => _$AuthReqPasswordChangeToJson(this);

  factory AuthReqPasswordChange.fromJson(Map<String, dynamic> json) => _$AuthReqPasswordChangeFromJson(json);
}
