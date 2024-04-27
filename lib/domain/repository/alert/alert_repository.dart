import 'package:dio/dio.dart' hide Headers;
import 'package:mediport/core/constant/data.dart';
import 'package:mediport/core/provider/dio_provider.dart';
import 'package:mediport/domain/model/alert/req/alert_req_register.dart';
import 'package:mediport/domain/model/alert/req/alert_req_update.dart';
import 'package:mediport/domain/model/alert/res/alert_res_detail.dart';
import 'package:mediport/domain/model/alert/res/alert_res_list.dart';
import 'package:mediport/domain/model/alert/res/alert_res_register.dart';
import 'package:mediport/domain/model/base_res.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'alert_repository.g.dart';

@Riverpod(keepAlive: true)
AlertRepository alertRepository(AlertRepositoryRef ref) => AlertRepository(ref.watch(dioProvider), baseUrl: '$baseHostV1/alert');

@RestApi()
abstract class AlertRepository {
  factory AlertRepository(Dio dio, { String baseUrl }) = _AlertRepository;

  @POST('/register')
  @Headers({'authorization': 'true'})
  Future<BaseResponse<AlertResRegister>> register({
    @Body() required AlertReqRegister body,
  });

  @GET('/list')
  @Headers({'authorization': 'true'})
  Future<BaseResponse<List<AlertResList>>> list({
    @Query('page') int? page,
    @Query('limit') int? limit = 15,
  });

  @GET('/detail')
  @Headers({'authorization': 'true'})
  Future<BaseResponse<AlertResDetail>> detail({
    @Query('id') required int id,
  });

  @PUT('/update')
  @Headers({'authorization': 'true'})
  Future<BaseResponse> update({
    @Query('id') required int id,
    @Body() required AlertReqUpdate body,
  });

  @DELETE('/remove')
  @Headers({'authorization': 'true'})
  Future<BaseResponse> remove({
    @Query('id') required int id,
  });
}