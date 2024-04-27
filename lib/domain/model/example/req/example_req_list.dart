import 'package:json_annotation/json_annotation.dart';

part 'example_req_list.g.dart';

// TODO: 각 모델의 이름은 [domain]_[req/res]_[API Suffix].dart 로 명명한다.
@JsonSerializable()
class ExampleReqList {
  final String title;
  final String content;

  ExampleReqList({
    required this.title,
    required this.content,
  });

  factory ExampleReqList.fromJson(Map<String, dynamic> json)
  => _$ExampleReqListFromJson(json);
}
