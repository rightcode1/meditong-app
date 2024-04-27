import 'package:json_annotation/json_annotation.dart';

part 'auth_req_join.g.dart';

@JsonSerializable()
class AuthReqJoin {
  final String loginId;
  final String password;
  final String tel;
  final String name;

  const AuthReqJoin({
    required this.loginId,
    required this.password,
    required this.tel,
    required this.name,
  });

  factory AuthReqJoin.fromJson(Map<String, dynamic> json) => _$AuthReqJoinFromJson(json);
  Map<String, dynamic> toJson() => _$AuthReqJoinToJson(this);
}
