
import 'package:json_annotation/json_annotation.dart';

part 'example_res_list.g.dart';

// TODO: 각 모델의 이름은 [domain]_[req/res]_[API Suffix].dart 로 명명한다.
@JsonSerializable()
class ExampleResList {
  final int id;
  final String title;
  final String content;
  final String createdAt;
  final String updatedAt;

  ExampleResList({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => _$ExampleResListToJson(this);
}
