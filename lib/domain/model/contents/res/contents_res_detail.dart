import 'package:json_annotation/json_annotation.dart';

part 'contents_res_detail.g.dart';

@JsonSerializable()
class ContentsResDetail {
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
  final List<ContentsResDetailHashtag> hashtags;
  final List<ContentsResDetailContentsDetail> contentsDetails;
  final ContentsResDetailCategory category;

  ContentsResDetail({
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
    required this.hashtags,
    required this.contentsDetails,
    required this.category,
  });

  ContentsResDetail copyWith({
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
    List<ContentsResDetailHashtag>? hashtags,
    List<ContentsResDetailContentsDetail>? contentsDetails,
    ContentsResDetailCategory? category,
  }) =>
      ContentsResDetail(
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
        hashtags: hashtags ?? this.hashtags,
        contentsDetails: contentsDetails ?? this.contentsDetails,
        category: category ?? this.category,
      );

  factory ContentsResDetail.fromJson(Map<String ,dynamic> json) => _$ContentsResDetailFromJson(json);

  @override
  String toString() {
    return 'ContentsResDetail{id: $id, categoryId: $categoryId, userId: $userId, title: $title, diff: $diff, viewCount: $viewCount, wishCount: $wishCount, commentCount: $commentCount, isHome: $isHome, createdAt: $createdAt, thumbnail: $thumbnail, hashtags: $hashtags, contentsDetails: $contentsDetails, category: $category}';
  }
}

@JsonSerializable()
class ContentsResDetailCategory {
  final int id;
  final String diff;
  final String primary;
  final String name;
  final bool isHome;
  final String createdAt;

  ContentsResDetailCategory({
    required this.id,
    required this.diff,
    required this.primary,
    required this.name,
    required this.isHome,
    required this.createdAt,
  });

  ContentsResDetailCategory copyWith({
    int? id,
    String? diff,
    String? primary,
    String? name,
    bool? isHome,
    String? createdAt,
  }) =>
      ContentsResDetailCategory(
        id: id ?? this.id,
        diff: diff ?? this.diff,
        primary: primary ?? this.primary,
        name: name ?? this.name,
        isHome: isHome ?? this.isHome,
        createdAt: createdAt ?? this.createdAt,
      );

  factory ContentsResDetailCategory.fromJson(Map<String ,dynamic> json) => _$ContentsResDetailCategoryFromJson(json);

  @override
  String toString() {
    return 'ContentsResDetailCategory{id: $id, diff: $diff, primary: $primary, name: $name, isHome: $isHome, createdAt: $createdAt}';
  }
}

@JsonSerializable()
class ContentsResDetailContentsDetail {
  final int id;
  final int contentsId;
  final String content;
  final String createdAt;
  final String? thumbnail;

  ContentsResDetailContentsDetail({
    required this.id,
    required this.contentsId,
    required this.content,
    required this.createdAt,
    required this.thumbnail,
  });

  ContentsResDetailContentsDetail copyWith({
    int? id,
    int? contentsId,
    String? content,
    String? createdAt,
    String? thumbnail,
  }) =>
      ContentsResDetailContentsDetail(
        id: id ?? this.id,
        contentsId: contentsId ?? this.contentsId,
        content: content ?? this.content,
        createdAt: createdAt ?? this.createdAt,
        thumbnail: thumbnail ?? this.thumbnail,
      );

  factory ContentsResDetailContentsDetail.fromJson(Map<String ,dynamic> json) => _$ContentsResDetailContentsDetailFromJson(json);

  @override
  String toString() {
    return 'ContentsResDetailContentsDetail{id: $id, contentsId: $contentsId, content: $content, createdAt: $createdAt, thumbnail: $thumbnail}';
  }
}

@JsonSerializable()
class ContentsResDetailHashtag {
  final int id;
  final String content;
  final bool active;
  final String createdAt;

  ContentsResDetailHashtag({
    required this.id,
    required this.content,
    required this.active,
    required this.createdAt,
  });

  ContentsResDetailHashtag copyWith({
    int? id,
    String? content,
    bool? active,
    String? createdAt,
  }) =>
      ContentsResDetailHashtag(
        id: id ?? this.id,
        content: content ?? this.content,
        active: active ?? this.active,
        createdAt: createdAt ?? this.createdAt,
      );

  factory ContentsResDetailHashtag.fromJson(Map<String ,dynamic> json) => _$ContentsResDetailHashtagFromJson(json);

  @override
  String toString() {
    return 'ContentsResDetailHashtag{id: $id, content: $content, active: $active, createdAt: $createdAt}';
  }
}