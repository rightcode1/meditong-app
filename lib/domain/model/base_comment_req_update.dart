import 'package:json_annotation/json_annotation.dart';

part 'base_comment_req_update.g.dart';

@JsonSerializable()
class BaseCommentReqUpdate {
  final String content;

  BaseCommentReqUpdate({
    required this.content,
  });

  Map<String, dynamic> toJson() => _$BaseCommentReqUpdateToJson(this);
}
