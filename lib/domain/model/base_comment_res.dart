import 'package:meditong/domain/model/user/res/user_res.dart';
import 'package:json_annotation/json_annotation.dart';

part 'base_comment_res.g.dart';

@JsonSerializable()
class BaseCommentRes {
  final int id;
  final int userId;
  final String content;
  final int depth;
  final String createdAt;
  final UserRes user;

  BaseCommentRes({
    required this.id,
    required this.userId,
    required this.content,
    required this.depth,
    required this.createdAt,
    required this.user,
  });

  factory BaseCommentRes.fromJson(Map<String, dynamic> json) => _$BaseCommentResFromJson(json);
}
