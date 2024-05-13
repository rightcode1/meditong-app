import 'package:flutter/material.dart';
import 'package:mediport/core/exception/request_exception.dart';
import 'package:mediport/domain/model/hashtag/res/hashtag_res_list.dart';
import 'package:mediport/domain/repository/hashtag/hashtag_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hashtag_providers.g.dart';

@riverpod
Future<List<HashtagResList>> hashtagList(HashtagListRef ref) async {
  try {
    final response = await ref.read(hashtagRepositoryProvider).list();

    return response.data!;
  } catch (err, stack) {
    debugPrint(err.toString());
    debugPrint(stack.toString());

    throw RequestException(message: err.toString());
  }
}