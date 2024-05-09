import 'package:json_annotation/json_annotation.dart';

part 'contents_comment_req_update.g.dart';

@JsonSerializable()
class ContentsCommentReqUpdate {
  final String? content;
  final int? contentsCommentId;

  ContentsCommentReqUpdate({
    this.content,
    this.contentsCommentId,
  });

  Map<String, dynamic> toJson() => _$ContentsCommentReqUpdateToJson(this);

  @override
  String toString() {
    return 'ContentsCommentReqUpdate{content: $content, contentsCommentId: $contentsCommentId}';
  }
}