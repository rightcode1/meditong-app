import 'package:flutter/material.dart';
import 'package:mediport/core/exception/request_exception.dart';
import 'package:mediport/domain/model/category/res/category_res_list.dart';
import 'package:mediport/domain/repository/category/category_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_providers.g.dart';

@riverpod
Future<List<CategoryResList>> categoryList(
  CategoryListRef ref, {
  required String diff,
}) async {
  try {
    final response = await ref.watch(categoryRepositoryProvider).list(diff: diff);

    return response.data!;
  } catch (err, stack) {
    debugPrint(err.toString());
    debugPrint(stack.toString());

    throw RequestException(message: err.toString());
  }
}
