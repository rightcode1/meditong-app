import 'package:json_annotation/json_annotation.dart';

import '../../user/res/user_res.dart';

part 'inquiry_res.g.dart';

@JsonSerializable()
class InquiryRes {
  final int id;
  final String title;
  final String content;
  final String? replyTitle;
  final String? replyContent;
  final String? replyDate;
  final String? memo;
  final String createdAt;
  final UserRes user;

  InquiryRes({
    required this.id,
    required this.title,
    required this.content,
    required this.replyTitle,
    required this.replyContent,
    required this.replyDate,
    required this.memo,
    required this.createdAt,
    required this.user,
  });

  factory InquiryRes.fromJson(Map<String ,dynamic> json) => _$InquiryResFromJson(json);
}