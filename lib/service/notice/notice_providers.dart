import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/model/notice/res/notice_res_detail.dart';
import '../../domain/repository/notice/notice_repository.dart';

part 'notice_providers.g.dart';

@Riverpod()
Future<void> noticePagingList(NoticePagingListRef ref, {
  required PagingController pagingController,
}) async {
  try {
    final currentPage = pagingController.nextPageKey;
    final response = await ref.read(noticeRepositoryProvider).list(
      page: currentPage,
      limit: 15,
    );

    final data = response.data!;
    final totalPage = response.meta!.totalPage;

    final isLastPage = currentPage == totalPage;

    if (!isLastPage) {
      pagingController.appendPage(data, currentPage + 1);
    } else {
      pagingController.appendLastPage(data);
    }
  } catch (err, stack) {
    debugPrint(err.toString());
    debugPrint(stack.toString());

    pagingController.error = err;
  }
}

@Riverpod()
Future<NoticeResDetail> noticeDetail(NoticeDetailRef ref, { required int noticeId }) async {
  try {
    final response = await ref.read(noticeRepositoryProvider).detail(id: noticeId);
    return response.data!;
  } catch (err, stack) {
    debugPrint(err.toString());
    debugPrint(stack.toString());

    throw Exception('서버 요청 중 오류가 발생했습니다.');
  }
}