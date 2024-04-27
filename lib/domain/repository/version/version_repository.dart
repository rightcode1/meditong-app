import 'package:mediport/core/constant/data.dart';
import 'package:mediport/core/provider/dio_provider.dart';
import 'package:mediport/domain/model/base_res.dart';
import 'package:mediport/domain/model/version/req/version_req_update.dart';
import 'package:mediport/domain/model/version/res/version_res.dart';
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