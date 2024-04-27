import 'package:json_annotation/json_annotation.dart';

part 'alert_req_update.g.dart';

@JsonSerializable()
class AlertReqUpdate {
  final String? content;
  final int? userId;

  const AlertReqUpdate({
    this.content,
    this.userId,
  });

  AlertReqUpdate copyWith({
    String? content,
    int? userId,
  }) {
    return AlertReqUpdate(
      content: content ?? this.content,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toJson() => _$AlertReqUpdateToJson(this);
}