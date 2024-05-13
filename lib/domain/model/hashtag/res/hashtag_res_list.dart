import 'package:json_annotation/json_annotation.dart';

part 'hashtag_res_list.g.dart';

@JsonSerializable()
class HashtagResList {
  final int id;
  final String content;
  final bool active;
  final DateTime createdAt;

  HashtagResList({
    required this.id,
    required this.content,
    required this.active,
    required this.createdAt,
  });

  factory HashtagResList.fromJson(Map<String, dynamic> json) => _$HashtagResListFromJson(json);
}