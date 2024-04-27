import 'package:json_annotation/json_annotation.dart';

part 'alert_res_detail.g.dart';

@JsonSerializable()
class AlertResDetail {
  final int id;
  final String content;
  final int userId;
  final DateTime createdAt;

  const AlertResDetail({
    required this.id,
    required this.content,
    required this.userId,
    required this.createdAt,
  });

  factory AlertResDetail.fromJson(Map<String ,dynamic> json) => _$AlertResDetailFromJson(json);

  @override
  String toString() {
    return 'AlertResDetail{id: $id, content: $content, userId: $userId, createdAt: $createdAt}';
  }
}