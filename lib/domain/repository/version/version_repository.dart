import 'package:meditong/core/constant/data.dart';
import 'package:meditong/core/provider/dio_provider.dart';
import 'package:meditong/domain/model/base_res.dart';
import 'package:meditong/domain/model/version/req/version_req_update.dart';
import 'package:meditong/domain/model/version/res/version_res.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'version_repository.g.dart';

final versionRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  const String baseUrl = '$baseHostV1/version';

  return VersionRepository(dio, baseUrl: baseUrl);
});

@RestApi()
abstract class VersionRepository {
  factory VersionRepository(Dio dio, { String baseUrl }) = _VersionRepository;

  @GET('')
  Future<BaseResponse<VersionRes>> version();

  @PUT('/update')
  // @Headers({'authorization': 'true'})
  Future<HttpResponse> update({
    @Body() required VersionReqUpdate body,
  });
}