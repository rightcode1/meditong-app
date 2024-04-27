import 'package:json_annotation/json_annotation.dart';

part 'notification_req_register.g.dart';

@JsonSerializable(includeIfNull: false)
class NotificationReqRegister {
  final String deviceId;
  final String notificationToken;
  final int? userId;

  NotificationReqRegister({
    required this.deviceId,
    required this.notificationToken,
    this.userId,
  });

  Map<String, dynamic> toJson() => _$NotificationReqRegisterToJson(this);
}