import 'package:json_annotation/json_annotation.dart';

part 'contents_comment_res_list.g.dart';

@JsonSerializable()
class ContentsCommentResList {
  final int id;
  final int userId;
  final int? contentsCommentId;
  final int contentsId;
  final String content;
  final int depth;
  final String? createdAt;
  final String? deletedAt;
  final ContentsCommentResListUser user;
  final bool isDeleted;

  ContentsCommentResList({
    required this.id,
    required this.userId,
    required this.contentsCommentId,
    required this.contentsId,
    required this.content,
    required this.depth,
    required this.createdAt,
    required this.deletedAt,
    required this.user,
    required this.isDeleted,
  });

  ContentsCommentResList copyWith({
    int? id,
    int? userId,
    int? contentsCommentId,
    int? contentsId,
    String? content,
    int? depth,
    String? createdAt,
    String? deletedAt,
    ContentsCommentResListUser? user,
    bool? isDeleted,
  }) =>
      ContentsCommentResList(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        contentsCommentId: contentsCommentId ?? this.contentsCommentId,
        contentsId: contentsId ?? this.contentsId,
        content: content ?? this.content,
        depth: depth ?? this.depth,
        createdAt: createdAt ?? this.createdAt,
        deletedAt: deletedAt ?? this.deletedAt,
        user: user ?? this.user,
        isDeleted: isDeleted ?? this.isDeleted,
      );
  
  factory ContentsCommentResList.fromJson(Map<String ,dynamic> json) => _$ContentsCommentResListFromJson(json);
}

@JsonSerializable()
class ContentsCommentResListUser {
  final int id;
  final String loginId;
  final String tel;
  final String name;
  final String role;
  final bool active;

  ContentsCommentResListUser({
    required this.id,
    required this.loginId,
    required this.tel,
    required this.name,
    required this.role,
    required this.active,
  });

  ContentsCommentResListUser copyWith({
    int? id,
    String? loginId,
    String? tel,
    String? name,
    String? role,
    bool? active,
  }) =>
      ContentsCommentResListUser(
        id: id ?? this.id,
        loginId: loginId ?? this.loginId,
        tel: tel ?? this.tel,
        name: name ?? this.name,
        role: role ?? this.role,
        active: active ?? this.active,
      );
  
  factory ContentsCommentResListUser.fromJson(Map<String ,dynamic> json) => _$ContentsCommentResListUserFromJson(json);
}