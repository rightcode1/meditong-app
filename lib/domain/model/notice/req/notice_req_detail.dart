import 'package:json_annotation/json_annotation.dart';

part 'notice_req_detail.g.dart';

@JsonSerializable()
class NoticeReqDetail {
  final int id;

  NoticeReqDetail({
    required this.id,
  });

  factory NoticeReqDetail.fromJson(Map<String, dynamic> json) => _$NoticeReqDetailFromJson(json);

  Map<String, dynamic> toJson() => _$NoticeReqDetailToJson(this);
}
