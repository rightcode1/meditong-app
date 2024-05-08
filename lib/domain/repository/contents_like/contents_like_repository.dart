import 'package:dio/dio.dart' hide Headers;
import 'package:mediport/core/constant/data.dart';
import 'package:mediport/core/provider/dio_provider.dart';
import 'package:mediport/domain/model/contents_like/req/contents_like_req_register.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/base_res.dart';

part 'contents_like_repository.g.dart';

@Riverpod(keepAlive: true)
ContentsLikeRepository contentsLikeRepository(ContentsLikeRepositoryRef ref) => ContentsLikeRepository(ref.watch(dioProvider), baseUrl: '$baseHostV1/contentsLike');

@RestApi()
abstract class ContentsLikeRepository {
  factory ContentsLikeRepository(Dio dio, { String baseUrl }) = _ContentsLikeRepository;

  @POST('/register')
  @Headers({'authorization': 'true'})
  Future<BaseResponse> register({
    @Body() required ContentsLikeReqRegister body,
  });

  @DELETE('/remove')
  @Headers({'authorization': 'true'})
  Future<BaseResponse> remove({
    @Query('id') required int id,
  });
}