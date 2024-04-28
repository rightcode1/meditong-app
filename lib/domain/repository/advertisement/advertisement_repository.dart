import 'package:dio/dio.dart' hide Headers;
import 'package:mediport/core/constant/data.dart';
import 'package:mediport/core/provider/dio_provider.dart';
import 'package:mediport/domain/model/advertisement/res/advertisement_res_list.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/advertisement/res/advertisement_res_detail.dart';
import '../../model/base_res.dart';

part 'advertisement_repository.g.dart';

@Riverpod(keepAlive: true)
AdvertisementRepository advertisementRepository(AdvertisementRepositoryRef ref) =>
    AdvertisementRepository(ref.watch(dioProvider), baseUrl: '$baseHostV1/advertisement');

@RestApi()
abstract class AdvertisementRepository {
  factory AdvertisementRepository(Dio dio, {String baseUrl}) = _AdvertisementRepository;

  @GET('/list')
  @Headers({'authorization': 'true'})
  Future<BaseResponse<List<AdvertisementResList>>> list({
    @Query('page') int? page,
    @Query('limit') int? limit = 15,
    @Query('location') String? location,
    @Query('active') bool? active,
  });

  @GET('/detail')
  @Headers({'authorization': 'true'})
  Future<BaseResponse<AdvertisementResDetail>> detail({
    @Query('id') required int id,
  });
}
