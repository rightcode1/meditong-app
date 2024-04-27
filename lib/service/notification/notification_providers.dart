import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:meditong/core/exception/request_exception.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/model/notification/req/notification_req_update.dart';
import '../../domain/model/notification/res/notification_res_detail.dart';
import '../../domain/repository/notification/notification_repository.dart';

part 'notification_providers.g.dart';

@Riverpod()
Future<NotificationResDetail> notificationDetail(NotificationDetailRef ref) async {
  try {
    late final String deviceId;
    if (Platform.isAndroid) {
      const androidId = AndroidId();
      deviceId = (await androidId.getId())!;
    } else {
      final deviceInfo = await DeviceInfoPlugin().iosInfo;
      deviceId = deviceInfo.identifierForVendor!;
    }

    return ref.read(notificationRepositoryProvider).detail(deviceId: deviceId).then((value) => value.data!);
  } catch (err, stack) {
    debugPrint(err.toString());
    debugPrint(stack.toString());

    throw RequestException(message: err.toString());
  }
}

@Riverpod()
Future<void> notificationUpdate(NotificationUpdateRef ref, {bool? ad}) async {
  try {
    late final String deviceId;

    if (Platform.isAndroid) {
      const androidId = AndroidId();
      deviceId = (await androidId.getId())!;
    } else {
      final deviceInfo = await DeviceInfoPlugin().iosInfo;
      deviceId = deviceInfo.identifierForVendor!;
    }

    final requestDto = NotificationReqUpdate(
      ad: ad.toString(),
    );

    await ref.read(notificationRepositoryProvider).update(deviceId: deviceId, body: requestDto);
  } catch (err, stack) {
    debugPrint(err.toString());
    debugPrint(stack.toString());

    throw RequestException(message: err.toString());
  }
}
