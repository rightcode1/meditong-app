import 'package:json_annotation/json_annotation.dart';

part 'base_image_res.g.dart';

@JsonSerializable()
class BaseImageRes {
  final int? id;
  final String name;

  BaseImageRes({
    this.id,
    required this.name,
  });

  factory BaseImageRes.fromJson(Map<String, dynamic> json) => _$BaseImageResFromJson(json);

  @override
  String toString() {
    return 'ImageRes{id: $id, name: $name}';
  }
}
