import 'package:json_annotation/json_annotation.dart';

part 'alert_res_list.g.dart';

@JsonSerializable()
class AlertResList {
  final int id;
  final String content;
  final int userId;
  final DateTime createdAt;

  const AlertResList({
    required this.id,
    required this.content,
    required this.userId,
    required this.createdAt,
  });

  AlertResList copyWith({
    int? id,
    String? content,
    int? userId,
    DateTime? createdAt,
  }) {
    return AlertResList(
      id: id ?? this.id,
      content: content ?? this.content,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory AlertResList.fromJson(Map<String, dynamic> json) => _$AlertResListFromJson(json);

  @override
  String toString() {
    return 'AlertResList{id: $id, content: $content, userId: $userId, createdAt: $createdAt}';
  }
}
