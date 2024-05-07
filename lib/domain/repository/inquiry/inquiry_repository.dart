import 'package:dio/dio.dart' hide Headers;
import 'package:mediport/core/constant/data.dart';
import 'package:mediport/core/provider/dio_provider.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/base_res.dart';
import '../../model/inquiry/req/inquiry_req_register.dart';
import '../../model/inquiry/res/inquiry_res.dart';

part 'inquiry_repository.g.dart';

@Riverpod()
InquiryRepository inquiryRepository(InquiryRepositoryRef ref) => InquiryRepository(ref.watch(dioProvider), baseUrl: '$baseHostV1/inquiry');

@RestApi()
abstract class InquiryRepository {
  factory InquiryRepository(Dio dio, { String baseUrl }) = _InquiryRepository;

  @POST('/register')
  @Headers({'authorization': 'true'})
  Future<BaseResponse> register({
    @Body() required InquiryReqRegister body,
  });

  @GET('/list')
  @Headers({'authorization': 'true'})
  Future<BaseResponse<List<InquiryRes>>> list({
    @Query('page') int? page,
    @Query('limit') int? limit = 15,
    @Query('userId') required int userId,
  });

  @GET('/detail')
  @Headers({'authorization': 'true'})
  Future<BaseResponse<InquiryRes>> detail({
    @Query('id') required int id,
  });
}