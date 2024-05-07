import 'package:json_annotation/json_annotation.dart';

part 'notice_req_list.g.dart';

@JsonSerializable(includeIfNull: false)
class NoticeReqList {
  final int? page;
  final int? limit;
  final String? search;
  final String? startDate;
  final String? endDate;

  NoticeReqList({
    required this.page,
    required this.limit,
    required this.search,
    required this.startDate,
    required this.endDate,
  });

  factory NoticeReqList.fromJson(Map<String, dynamic> json) => _$NoticeReqListFromJson(json);
  Map<String, dynamic> toJson() => _$NoticeReqListToJson(this);
}
