import 'package:json_annotation/json_annotation.dart';

part 'contents_like_req_register.g.dart';

@JsonSerializable()
class ContentsLikeReqRegister {
  final bool isLike;
  final int contentsId;

  ContentsLikeReqRegister({
    required this.isLike,
    required this.contentsId,
  });

  Map<String, dynamic> toJson() => _$ContentsLikeReqRegisterToJson(this);

  @override
  String toString() {
    return 'ContentsLikeReqRegister{isLike: $isLike, contentsId: $contentsId}';
  }
}