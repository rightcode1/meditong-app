import 'package:json_annotation/json_annotation.dart';

part 'notification_res_detail.g.dart';

@JsonSerializable()
class NotificationResDetail {
  final String deviceId;
  final String notificationToken;
  final int userId;
  final bool ad;

  NotificationResDetail({
    required this.deviceId,
    required this.notificationToken,
    required this.userId,
    required this.ad,
  });

  factory NotificationResDetail.fromJson(Map<String, dynamic> json) => _$NotificationResDetailFromJson(json);
}
