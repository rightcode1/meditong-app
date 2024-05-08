import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mediport/core/exception/request_exception.dart';
import 'package:mediport/domain/model/contents/res/contents_res_detail.dart';
import 'package:mediport/domain/model/contents/res/contents_res_list.dart';
import 'package:mediport/domain/repository/contents/contents_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contents_providers.g.dart';

final contentTotalCountProvider = StateProvider((ref) => 0);

@riverpod
Future<void> contentPagingList(
  ContentPagingListRef ref, {
  required PagingController pagingController,
  String? diff,
  String? primary,
  String? subCategory,
  bool? isHome,
  String? sort,
}) async {
  try {
    final currentPage = pagingController.nextPageKey;

    final response = await ref.read(contentsRepositoryProvider).list(
          page: currentPage,
          limit: 15,
          diff: diff,
          primary: primary,
          subCategory: subCategory,
          isHome: isHome,
          sort: sort,
        );

    final data = response.data!;
    final meta = response.meta!;

    final isLastPage = meta.totalPage == currentPage;

    if (!isLastPage) {
      pagingController.appendPage(data, currentPage + 1);
    } else {
      pagingController.appendLastPage(data);
    }

    ref.read(contentTotalCountProvider.notifier).state = meta.totalCount;
  } catch (err, stack) {
    debugPrint(err.toString());
    debugPrint(stack.toString());

    pagingController.error = err;
  }
}

@riverpod
Future<List<ContentsResList>> contentsList(
  ContentsListRef ref, {
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

@riverpod
Future<ContentsResDetail> contentsDetail(ContentsDetailRef ref, { required int contentsId }) async {
  try {
    final response = await ref.read(contentsRepositoryProvider).detail(id: contentsId);
    return response.data!;
  } catch (err, stack) {
    debugPrint(err.toString());
    debugPrint(stack.toString());

    throw RequestException(message: err.toString());
  }
}