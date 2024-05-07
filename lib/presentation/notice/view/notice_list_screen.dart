import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mediport/core/component/.etc/no_list_widget.dart';
import 'package:mediport/core/constant/app_color.dart';
import 'package:mediport/core/enum/app_router.dart';
import 'package:mediport/core/layout/default_layout.dart';

import '../../../domain/model/notice/res/notice_res_list.dart';
import '../../../service/notice/notice_providers.dart';

class NoticeListScreen extends ConsumerStatefulWidget {
  const NoticeListScreen({super.key});

  @override
  ConsumerState createState() => _NoticeListScreenState();
}

class _NoticeListScreenState extends ConsumerState<NoticeListScreen> {
  final _pagingController = PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();

    _pagingController.addPageRequestListener(
      (pageKey) => ref.read(noticePagingListProvider(pagingController: _pagingController)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '공지사항',
      showBack: true,
      showAppBar: true,
      padding: EdgeInsets.zero,
      child: RefreshIndicator(
        onRefresh: () async => _pagingController.refresh(),
        child: PagedListView(
          padding: EdgeInsets.only(top: 20.0.h),
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate(
            animateTransitions: true,
            itemBuilder: (context, item, index) {
              final eachNotice = item as NoticeResList;
              return GestureDetector(
                onTap: () {
                  context.pushNamed(AppRouter.noticeDetail.name, queryParameters: {'id': eachNotice.id.toString()});
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              eachNotice.title,
                              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.black),
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              eachNotice.createdAt,
                              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: AppColor.darkGrey300),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0.h),
                      const Divider(height: 0.0, color: AppColor.grey500),
                      SizedBox(height: 20.0.h),
                    ],
                  ),
                ),
              );
            },
            noItemsFoundIndicatorBuilder: (context) => Padding(
              padding: EdgeInsets.only(top: 150.0.h),
              child: const NoListWidget(text: '등록된 공지사항이 없습니다.'),
            ),
          ),
        ),
      ),
    );
  }
}
