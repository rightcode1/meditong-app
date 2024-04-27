import 'package:flutter/rendering.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mediport/core/exception/request_exception.dart';
import 'package:mediport/domain/repository/alert/alert_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'alert_providers.g.dart';

@riverpod
Future<void> alertRegister(AlertRegisterRef ref) async {
  try {

  } catch (err, stack) {
    debugPrint(err.toString());
    debugPrint(stack.toString());

    throw RequestException(message: err.toString());
  }
}

@riverpod
class AlertPagingList extends _$AlertPagingList {
  @override
  void build({ required PagingController pagingController }) async {
    return fetchData(pagingController: pagingController);
  }

  void fetchData({ required PagingController pagingController }) async {
    try {
      final currentPage = pagingController.nextPageKey;

      final response = await ref.read(alertRepositoryProvider).list(page: currentPage, limit: 15);

      final data = response.data!;

      final totalPage = response.meta!.totalPage;
      final isLastPage = currentPage == totalPage;

      if (isLastPage) {
        pagingController.appendLastPage(data);
      } else {
        final nextPage = currentPage + 1;
        pagingController.appendPage(data, nextPage);
      }
    } catch (err, stack) {
      debugPrint(err.toString());
      debugPrint(stack.toString());

      pagingController.error = err;
    }
  }
}