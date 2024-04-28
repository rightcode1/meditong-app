import 'package:flutter/material.dart';
import 'package:mediport/core/exception/request_exception.dart';
import 'package:mediport/domain/model/advertisement/res/advertisement_res_list.dart';
import 'package:mediport/domain/repository/advertisement/advertisement_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/model/advertisement/res/advertisement_res_detail.dart';

part 'advertisement_providers.g.dart';

@riverpod
Future<List<AdvertisementResList>> advertisementList(AdvertisementListRef ref, { String? location, bool? active }) async {
  try {
    final response = await ref.read(advertisementRepositoryProvider).list(location: location, active: active);

    return response.data!;
  } catch (err, stack) {
    debugPrint(err.toString());
    debugPrint(stack.toString());

    throw RequestException(message: err.toString());
  }
}

@riverpod
Future<AdvertisementResDetail> advertisementDetail(AdvertisementDetailRef ref, { required int advertisementId }) async {
  try {
    final response = await ref.read(advertisementRepositoryProvider).detail(id: advertisementId);

    return response.data!;
  } catch (err, stack) {
    debugPrint(err.toString());
    debugPrint(stack.toString());

    throw RequestException(message: err.toString());
  }
}