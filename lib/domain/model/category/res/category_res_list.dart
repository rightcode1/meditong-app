import 'package:json_annotation/json_annotation.dart';

part 'category_res_list.g.dart';

@JsonSerializable()
class CategoryResList {
  final int id;
  final String diff;
  final String primary;
  final String name;
  final bool isHome;
  final DateTime createdAt;

  const CategoryResList({
    required this.id,
    required this.diff,
    required this.primary,
    required this.name,
    required this.isHome,
    required this.createdAt,
  });

  factory CategoryResList.fromJson(Map<String, dynamic> json) => _$CategoryResListFromJson(json);

  @override
  String toString() {
    return 'CategoryResList{id: $id, diff: $diff, primary: $primary, name: $name, isHome: $isHome, createdAt: $createdAt}';
  }
}
