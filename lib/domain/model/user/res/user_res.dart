import 'package:json_annotation/json_annotation.dart';

part 'user_res.g.dart';

abstract class UserResBase {}

class UserResError extends UserResBase {
  final String message;

  UserResError({
    required this.message,
  });
}

class UserResLoading extends UserResBase {}

/// 기본 유저 모델, API 명세서에 따라 적절히 변형하여 사용한다.
@JsonSerializable()
class UserRes extends UserResBase {
  final int id;
  final String loginId;
  final String name;
  final String tel;
  final String role;
  final bool active;

  UserRes({
    required this.id,
    required this.loginId,
    required this.tel,
    required this.name,
    required this.role,
    required this.active,
  });

  factory UserRes.fromJson(Map<String, dynamic> json) => _$UserResFromJson(json);
}