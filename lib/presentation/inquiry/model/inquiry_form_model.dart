import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

part 'inquiry_form_model.g.dart';

@JsonSerializable()
class InquiryFormModel {
  final String? title;
  final String? content;

  InquiryFormModel({
    this.title,
    this.content,
  });

  bool get isAllValidated {
    final validTitle = title != null && title!.isNotEmpty;
    final validContent = content != null && content!.isNotEmpty;

    return validTitle && validContent;
  }

  InquiryFormModel copyWith({
    String? title,
    String? content,
    List<File>? images,
  }) {
    return InquiryFormModel(
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }

  Map<String, dynamic> toJson() => _$InquiryFormModelToJson(this);

  @override
  String toString() {
    return 'InquiryFormModel{title: $title, content: $content';
  }
}
