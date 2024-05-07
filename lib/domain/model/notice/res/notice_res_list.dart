import 'package:json_annotation/json_annotation.dart';

part 'notice_res_list.g.dart';

@JsonSerializable()
class NoticeResList {
  final int id;
  final int viewCount;
  final bool active;
  final String title;
  final String content;
  final String createdAt;

  NoticeResList({
    required this.id,
    required this.viewCount,
    required this.active,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  factory NoticeResList.fromJson(Map<String, dynamic> json) => _$NoticeResListFromJson(json);

  Map<String, dynamic> toJson() => _$NoticeResListToJson(this);
}
