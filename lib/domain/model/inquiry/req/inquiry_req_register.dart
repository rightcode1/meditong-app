import 'package:json_annotation/json_annotation.dart';

part 'inquiry_req_register.g.dart';

@JsonSerializable()
class InquiryReqRegister {
  final String title;
  final String content;

  InquiryReqRegister({
    required this.title,
    required this.content,
  });

  factory InquiryReqRegister.fromJson(Map<String, dynamic> json) => _$InquiryReqRegisterFromJson(json);

  Map<String, dynamic> toJson() => _$InquiryReqRegisterToJson(this);

  @override
  String toString() {
    return 'InquiryReqRegister{title: $title, content: $content}';
  }
}