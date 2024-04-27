import 'package:json_annotation/json_annotation.dart';

part 'base_comment_req_register.g.dart';

@JsonSerializable()
class BaseCommentReqRegister {
  final int id;
  final String content;

  ///동적으로 상기 id 프로퍼티의 이름을 직렬화 시 변경하기 위한 프로퍼티명
  ///ex. advertisementId 를 전달받을 경우, 상기 id 프로퍼티는 {"advertisementId": 1} 와 같이 변경되어 서버로 전송된다.
  final String idPropertyName;

  BaseCommentReqRegister({
    required this.id,
    required this.content,
    required this.idPropertyName,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data[idPropertyName] = id;
    data['content'] = content;

    return data;
  }
}
