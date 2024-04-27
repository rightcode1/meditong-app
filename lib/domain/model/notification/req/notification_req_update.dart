import 'package:json_annotation/json_annotation.dart';

part 'notification_req_update.g.dart';

@JsonSerializable()
class NotificationReqUpdate {
  final String? ad;

  NotificationReqUpdate({
    this.ad,
  });

  Map<String, dynamic> toJson() => _$NotificationReqUpdateToJson(this);
}
