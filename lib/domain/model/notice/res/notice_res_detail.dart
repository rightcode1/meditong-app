import 'package:json_annotation/json_annotation.dart';

part 'notice_res_detail.g.dart';

@JsonSerializable()
class NoticeResDetail {
  final int id;
  final int viewCount;
  final bool active;
  final String title;
  final String content;
  final String createdAt;

  NoticeResDetail({
    required this.id,
    required this.viewCount,
    required this.active,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  factory NoticeResDetail.fromJson(Map<String, dynamic> json) => _$NoticeResDetailFromJson(json);

  Map<String, dynamic> toJson() => _$NoticeResDetailToJson(this);
}
