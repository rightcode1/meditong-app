import 'package:json_annotation/json_annotation.dart';

part 'contents_comment_req_register.g.dart';

@JsonSerializable()
class ContentsCommentReqRegister {
  final int contentsId;
  final String content;
  final int? contentsCommentId;

  ContentsCommentReqRegister({
    required this.contentsId,
    required this.content,
    this.contentsCommentId,
  });

  Map<String, dynamic> toJson() => _$ContentsCommentReqRegisterToJson(this);

  @override
  String toString() {
    return 'ContentsCommentReqRegister{contentsId: $contentsId, content: $content, contentsCommentId: $contentsCommentId}';
  }
}
