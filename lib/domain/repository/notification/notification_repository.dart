import 'package:meditong/core/constant/data.dart';
import 'package:meditong/core/provider/dio_provider.dart';
import 'package:meditong/domain/model/base_res.dart';
import 'package:meditong/domain/model/notification/req/notification_req_update.dart';
import 'package:meditong/domain/model/notification/res/notification_res_detail.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'notification_repository.g.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final dio = ref.watch(dioProvider);
  const String baseUrl = '$baseHostV1/notification';

  return NotificationRepository(dio, baseUrl: baseUrl);
});

@RestApi()
abstract class NotificationRepository {
  factory NotificationRepository(Dio dio, {String baseUrl}) = _NotificationRepository;

  @GET('/detail')
  Future<BaseResponse<NotificationResDetail>> detail({
    @Query('deviceId') required String deviceId,
  });

  @PUT('/update')
  Future<BaseResponse> update({
    @Query('deviceId') required String deviceId,
    @Body() required NotificationReqUpdate body,
  });
}
