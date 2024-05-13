import 'package:dio/dio.dart' hide Headers;
import 'package:mediport/core/constant/data.dart';
import 'package:mediport/core/provider/dio_provider.dart';
import 'package:mediport/domain/model/hashtag/res/hashtag_res_list.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/base_res.dart';

part 'hashtag_repository.g.dart';

@Riverpod(keepAlive: true)
HashtagRepository hashtagRepository(HashtagRepositoryRef ref) => HashtagRepository(ref.watch(dioProvider), baseUrl: '$baseHostV1/hashtag');

@RestApi()
abstract class HashtagRepository {
  factory HashtagRepository(Dio dio, { String baseUrl }) = _HashtagRepository;

  @GET('/list')
  Future<BaseResponse<List<HashtagResList>>> list({
    @Query('page') int? page,
    @Query('limit') int? limit = 15,
  });
}