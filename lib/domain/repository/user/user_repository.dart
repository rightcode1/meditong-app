import 'package:meditong/domain/model/base_res.dart';
import 'package:meditong/domain/model/user/res/user_res.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:meditong/core/constant/data.dart';
import 'package:meditong/core/provider/dio_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'user_repository.g.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final baseUrl = '${baseHostV1}/user';

  return UserRepository(dio, baseUrl: baseUrl);
});

@RestApi()
abstract class UserRepository {
  factory UserRepository(Dio dio, {String baseUrl}) = _UserRepository;

  @GET('/info')
  @Headers({'authorization': 'true'})
  Future<BaseResponse<UserRes>> info();

  @GET('/logout')
  @Headers({'authorization': 'true'})
  Future<BaseResponse> logout();

  // @PUT('/update')
  // @Headers({'authorization': 'true'})
  // Future<BaseResponse> update({
  //   @Body() required UserReqUpdate body,
  // });
  //
  // @DELETE('/withdrawal')
  // @Headers({'authorization': 'true'})
  // Future<BaseResponse> withdrawal();
  //
  // /// 프로필 사진 등록
  // @POST('/file/register')
  // @MultiPart()
  // @Headers({'authorization': 'true'})
  // Future<BaseResponse> fileRegister({
  //   @Part(name: 'image') required File profileImage,
  // });
  //
  // @GET('/list')
  // @Headers({'authorization': 'true'})
  // Future<OffsetPagination<UserReqList>?> list({
  //   @Query('recommendUserId') int? recommendUserId,
  //   @Query('isRecommend') String? isRecommend,
  // });
}
