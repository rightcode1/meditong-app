import 'package:mediport/core/exception/request_exception.dart';
import 'package:mediport/domain/model/version/req/version_req_update.dart';
import 'package:mediport/domain/repository/version/version_repository.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'version_providers.g.dart';

@riverpod
Future<void> versionUpdate(VersionUpdateRef ref, {
  String? aosStoreVer,
  String? iosStoreVer,
}) async {
  try {
    final requestDto = VersionReqUpdate(
      aosStoreVer: aosStoreVer,
      iosStoreVer: iosStoreVer,
    );

    await ref.read(versionRepositoryProvider).update(body: requestDto);
  } catch (err, stack) {
    debugPrint(err.toString());
    debugPrint(stack.toString());

    throw RequestException(message: err.toString());
  }
}