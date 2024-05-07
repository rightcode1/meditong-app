import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/http.dart';
import 'package:mediport/core/constant/data.dart';
import 'package:mediport/core/provider/dio_provider.dart';

import '../../model/base_res.dart';
import '../../model/notice/res/notice_res_detail.dart';
import '../../model/notice/res/notice_res_list.dart';

part 'notice_repository.g.dart';

final noticeRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  const String baseUrl = '$baseHostV1/notice';

  return NoticeRepository(dio, baseUrl: baseUrl);
});

@RestApi()
abstract class NoticeRepository {
  factory NoticeRepository(Dio dio, {String baseUrl}) = _NoticeRepository;

  @GET('/list')
  Future<BaseResponse<List<NoticeResList>>> list({
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('search') String? search,
    @Query('startDate') String? startDate,
    @Query('endDate') String? endDate,
  });

  @GET('/detail')
  @Headers({'authorization': 'true'})
  Future<BaseResponse<NoticeResDetail>> detail({
    @Query('id') required int id,
  });
}
