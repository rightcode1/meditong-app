import 'package:json_annotation/json_annotation.dart';

part 'alert_res_register.g.dart';

@JsonSerializable()
class AlertResRegister {
  final int id;
  final String content;
  final int userId;
  final DateTime updatedAt;
  final DateTime createdAt;
  
  const AlertResRegister({
    required this.id,
    required this.content,
    required this.userId,
    required this.updatedAt,
    required this.createdAt,
  });
  
  factory AlertResRegister.fromJson(Map<String ,dynamic> json) => _$AlertResRegisterFromJson(json);
}