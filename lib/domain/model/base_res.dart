import 'package:json_annotation/json_annotation.dart';

part 'base_res.g.dart';

/// 서버의 기본 Response 형태, 서버에 따라 항목이 달라질 수 있으므로 유의한다.
@JsonSerializable(genericArgumentFactories: true)
class BaseResponse<T> {
  final int statusCode;
  final String message;
  final String? token;
  final String? role;
  final BaseResponseMeta? meta;
  final T? data;

  BaseResponse({
    required this.statusCode,
    required this.message,
    this.token,
    this.role,
    this.meta,
    this.data,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) => _$BaseResponseFromJson(json, fromJsonT);

  @override
  String toString() {
    return 'BaseResponse{statusCode: $statusCode, message: $message, token: $token, role: $role, meta: $meta, data: $data}';
  }
}

@JsonSerializable()
class BaseResponseMeta {
  final int page;
  final int limit;
  final int totalPage;
  final int totalCount;

  BaseResponseMeta({
    required this.page,
    required this.limit,
    required this.totalPage,
    required this.totalCount,
  });

  factory BaseResponseMeta.fromJson(Map<String, dynamic> json) => _$BaseResponseMetaFromJson(json);

  @override
  String toString() {
    return 'BaseResponseMeta{page: $page, limit: $limit, totalPage: $totalPage, totalCount: $totalCount}';
  }
}