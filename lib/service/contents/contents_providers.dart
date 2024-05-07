import 'package:flutter/material.dart';
import 'package:mediport/core/exception/request_exception.dart';
import 'package:mediport/domain/model/contents/res/contents_res_list.dart';
import 'package:mediport/domain/repository/contents/contents_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contents_providers.g.dart';

@riverpod
Future<List<ContentsResList>> contentsList(ContentsListRef ref, {
  String? diff,
  String? primary,
  String? subCategory,
  bool? isHome,
}) async {
  try {
    final response = await ref.read(contentsRepositoryProvider).list(
      diff: diff,
      primary: primary,
      subCategory: subCategory,
      isHome: isHome,
    );

    return response.data!;
  } catch (err, stack) {
    debugPrint(err.toString());
    debugPrint(stack.toString());

    throw RequestException(message: err.toString());
  }
}