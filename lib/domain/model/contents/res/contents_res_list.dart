import 'package:json_annotation/json_annotation.dart';

part 'contents_res_list.g.dart';

@JsonSerializable()
class ContentsResList {
  final int id;
  final int categoryId;
  final int userId;
  final String title;
  final String diff;
  final int viewCount;
  final int wishCount;
  final int commentCount;
  final bool isHome;
  final DateTime createdAt;
  final String? thumbnail;
  final ContentsResListCategory category;

  ContentsResList({
    required this.id,
    required this.categoryId,
    required this.userId,
    required this.title,
    required this.diff,
    required this.viewCount,
    required this.wishCount,
    required this.commentCount,
    required this.isHome,
    required this.createdAt,
    required this.thumbnail,
    required this.category,
  });

  ContentsResList copyWith({
    int? id,
    int? categoryId,
    int? userId,
    String? title,
    String? diff,
    int? viewCount,
    int? wishCount,
    int? commentCount,
    bool? isHome,
    DateTime? createdAt,
    String? thumbnail,
    ContentsResListCategory? category,
  }) =>
      ContentsResList(
        id: id ?? this.id,
        categoryId: categoryId ?? this.categoryId,
        userId: userId ?? this.userId,
        title: title ?? this.title,
        diff: diff ?? this.diff,
        viewCount: viewCount ?? this.viewCount,
        wishCount: wishCount ?? this.wishCount,
        commentCount: commentCount ?? this.commentCount,
        isHome: isHome ?? this.isHome,
        createdAt: createdAt ?? this.createdAt,
        thumbnail: thumbnail ?? this.thumbnail,
        category: category ?? this.category,
      );

  factory ContentsResList.fromJson(Map<String ,dynamic> json) => _$ContentsResListFromJson(json);

  @override
  String toString() {
    return 'ContentsResList{id: $id, categoryId: $categoryId, userId: $userId, title: $title, diff: $diff, viewCount: $viewCount, wishCount: $wishCount, commentCount: $commentCount, isHome: $isHome, createdAt: $createdAt, thumbnail: $thumbnail, category: $category}';
  }
}

@JsonSerializable()
class ContentsResListCategory {
  final int id;
  final String diff;
  final String primary;
  final String name;
  final bool isHome;
  final String createdAt;

  ContentsResListCategory({
    required this.id,
    required this.diff,
    required this.primary,
    required this.name,
    required this.isHome,
    required this.createdAt,
  });

  ContentsResListCategory copyWith({
    int? id,
    String? diff,
    String? primary,
    String? name,
    bool? isHome,
    String? createdAt,
  }) =>
      ContentsResListCategory(
        id: id ?? this.id,
        diff: diff ?? this.diff,
        primary: primary ?? this.primary,
        name: name ?? this.name,
        isHome: isHome ?? this.isHome,
        createdAt: createdAt ?? this.createdAt,
      );

  factory ContentsResListCategory.fromJson(Map<String ,dynamic> json) => _$ContentsResListCategoryFromJson(json);

  @override
  String toString() {
    return 'ContentsResListCategory{id: $id, diff: $diff, primary: $primary, name: $name, isHome: $isHome, createdAt: $createdAt}';
  }
}