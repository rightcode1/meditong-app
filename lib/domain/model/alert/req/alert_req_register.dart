import 'package:json_annotation/json_annotation.dart';

part 'alert_req_register.g.dart';

@JsonSerializable()
class AlertReqRegister {
  final String content;
  final int userId;

  const AlertReqRegister({
    required this.content,
    required this.userId,
  });

  AlertReqRegister copyWith(
    String? content,
    int? userId,
      ) {
    return AlertReqRegister(
      content: content ?? this.content,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toJson() => _$AlertReqRegisterToJson(this);
  factory AlertReqRegister.fromJson(Map<String, dynamic> json) => _$AlertReqRegisterFromJson(json);

  @override
  String toString() {
    return 'AlertReqRegister{content: $content, userId: $userId}';
  }
}
