import 'package:dio/dio.dart' hide Headers;
import 'package:mediport/core/constant/data.dart';
import 'package:mediport/core/provider/dio_provider.dart';
import 'package:mediport/domain/model/contents_comment/req/contents_comment_req_register.dart';
import 'package:mediport/domain/model/contents_comment/req/contents_comment_req_update.dart';
import 'package:mediport/domain/model/contents_comment/res/contents_comment_res_list.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/base_res.dart';

part 'contents_comment_repository.g.dart';

@Riverpod(keepAlive: true)
ContentsCommentRepository contentsCommentRepository(ContentsCommentRepositoryRef ref) => _ContentsCommentRepository(ref.watch(dioProvider), baseUrl: '$baseHostV1/contentsComment');

@RestApi()
abstract class ContentsCommentRepository {
  factory ContentsCommentRepository(Dio dio, { String baseUrl })  = _ContentsCommentRepository;

  @POST('/register')
  @Headers({'authorization': 'true'})
  Future<BaseResponse> register({
    @Body() required ContentsCommentReqRegister body,
  });

  @GET('/list')
  @Headers({'authorization': 'true'})
  Future<BaseResponse<List<ContentsCommentResList>>> list({
    @Query('page') int? page,
    @Query('limit') int? limit = 15,
    @Query('contentsId') required int contentsId,
  });

  @PUT('/update')
  @Headers({'authorization': 'true'})
  Future<BaseResponse> update({
    @Query('id') required int id,
    @Body() required ContentsCommentReqUpdate body,
  });

  @DELETE('/remove')
  @Headers({'authorization': 'true'})
  Future<BaseResponse> remove({
    @Query('id') required int id,
  });
}