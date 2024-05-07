import 'package:dio/dio.dart' hide Headers;
import 'package:mediport/core/constant/data.dart';
import 'package:mediport/core/provider/dio_provider.dart';
import 'package:mediport/domain/model/contents/res/contents_res_detail.dart';
import 'package:mediport/domain/model/contents/res/contents_res_list.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/base_res.dart';

part 'contents_repository.g.dart';

@Riverpod(keepAlive: true)
ContentsRepository contentsRepository(ContentsRepositoryRef ref) => ContentsRepository(ref.watch(dioProvider), baseUrl: '$baseHostV1/contents');

@RestApi()
abstract class ContentsRepository {
  factory ContentsRepository(Dio dio, { String baseUrl }) = _ContentsRepository;

  @GET('/list')
  @Headers({'authorization': 'true'})
  Future<BaseResponse<List<ContentsResList>>> list({
    @Query('page') int? page,
    @Query('limit') int? limit = 15,
    @Query('diff') String? diff,
    @Query('primary') String? primary,
    @Query('name') String? subCategory,
    @Query('search') String? search,
    @Query('startDate') String? startDate,
    @Query('endDate') String? endDate,
    @Query('isHome') bool? isHome,
  });

  @GET('/detail')
  @Headers({'authorization': 'true'})
  Future<BaseResponse<ContentsResDetail>> detail({
    @Query('id') required int id,
  });
}