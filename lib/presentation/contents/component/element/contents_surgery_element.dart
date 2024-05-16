import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:mediport/core/component/.etc/no_list_widget.dart';
import 'package:mediport/core/component/buttons/common_button.dart';
import 'package:mediport/core/component/container/common_board_list_container.dart';
import 'package:mediport/core/constant/app_color.dart';
import 'package:mediport/core/util/bottom_sheet_utils.dart';
import 'package:mediport/domain/model/contents/res/contents_res_list.dart';
import 'package:mediport/service/contents/contents_providers.dart';

import '../../../../core/enum/app_router.dart';

class ContentsSurgeryElement extends ConsumerStatefulWidget {
  const ContentsSurgeryElement({
    super.key,
    required this.primary,
    required this.hashtagId,
  });

  final String primary;

  final int hashtagId;

  @override
  ConsumerState<ContentsSurgeryElement> createState() => _ContentsSurgeryElementState();
}

class _ContentsSurgeryElementState extends ConsumerState<ContentsSurgeryElement> {
  String get _primary => widget.primary;

  int get _hashtagId => widget.hashtagId;

  final _pagingController = PagingController(firstPageKey: 1);

  /// 현재 보기 모드
  CommonBoardListContainerMode _currentViewMode = CommonBoardListContainerMode.smallPic;

  /// 현재 정렬 모드
  String _currentSort = '최신순';

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) => ref.read(contentPagingListProvider(
          pagingController: _pagingController,
          hashtagId: _hashtagId,
          sort: _currentSort,
        ).future));

    super.initState();
  }

  @override
  void didUpdateWidget(covariant ContentsSurgeryElement oldWidget) {
    if (oldWidget.hashtagId != _hashtagId) {
      _pagingController.refresh();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$_primary을 소개해드립니다.',
              style: TextStyle(fontSize: 20.0.sp, fontWeight: FontWeight.w600),
            ),
            /* 필터 및 보기 */
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    BottomSheetUtils.showNoButton(
                      context: context,
                      title: '정렬',
                      showCloseBtn: false,
                      contentWidget: (bottomState) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 40.0.h),
                          child: Row(
                            children: [
                              Expanded(
                                child: CommonButton(
                                  backgroundColor: _currentSort == '최신순' ? Colors.white : AppColor.grey300,
                                  foregroundColor: AppColor.grey300,
                                  textColor: _currentSort == '최신순' ? AppColor.primary : AppColor.grey550,
                                  useBorder: _currentSort == '최신순',
                                  text: '최신순',
                                  onPressed: () {
                                    context.pop();
                                    _currentSort = '최신순';
                                    _pagingController.refresh();
                                    setState(() {});
                                  },
                                ),
                              ),
                              SizedBox(width: 14.0.w),
                              Expanded(
                                child: CommonButton(
                                  backgroundColor: _currentSort == '인기순' ? Colors.white : AppColor.grey300,
                                  foregroundColor: AppColor.grey300,
                                  textColor: _currentSort == '인기순' ? AppColor.primary : AppColor.grey550,
                                  useBorder: _currentSort == '인기순',
                                  text: '인기순',
                                  onPressed: () {
                                    context.pop();
                                    _currentSort = '인기순';
                                    _pagingController.refresh();
                                    setState(() {});
                                  },
                                ),
                              ),
                              SizedBox(width: 14.0.w),
                              Expanded(
                                child: CommonButton(
                                  backgroundColor: _currentSort == '댓글순' ? Colors.white : AppColor.grey300,
                                  foregroundColor: AppColor.grey300,
                                  textColor: _currentSort == '댓글순' ? AppColor.primary : AppColor.grey550,
                                  useBorder: _currentSort == '댓글순',
                                  text: '댓글순',
                                  onPressed: () {
                                    context.pop();
                                    _currentSort = '댓글순';
                                    _pagingController.refresh();
                                    setState(() {});
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 5.0.h),
                    child: Row(
                      children: [
                        Text(
                          _currentSort,
                          style: TextStyle(fontSize: 14.0.sp, fontWeight: FontWeight.w600, color: AppColor.cyan700),
                        ),
                        Icon(Icons.keyboard_arrow_down, color: AppColor.cyan700, size: 16.0.h),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 6.0.w),
                InkWell(
                  onTap: () {
                    setState(() {
                      _currentViewMode = _currentViewMode == CommonBoardListContainerMode.smallPic
                          ? CommonBoardListContainerMode.bigPic
                          : _currentViewMode == CommonBoardListContainerMode.bigPic
                              ? CommonBoardListContainerMode.onlyText
                              : CommonBoardListContainerMode.smallPic;
                    });
                  },
                  child: Image.asset(
                    _currentViewMode == CommonBoardListContainerMode.smallPic
                        ? 'assets/icons/board/board_small_pic@3x.png'
                        : _currentViewMode == CommonBoardListContainerMode.bigPic
                            ? 'assets/icons/board/board_big_pic@3x.png'
                            : 'assets/icons/board/board_only_text@3x.png',
                    height: 26.0.h,
                  ),
                )
              ],
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => _pagingController.refresh(),
                child: PagedListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 20.0.h),
                  physics: const AlwaysScrollableScrollPhysics(),
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate(
                    animateTransitions: true,
                    itemBuilder: (context, item, index) {
                      final each = item as ContentsResList;
                      return CommonBoardListContainer(
                        mode: _currentViewMode,
                        thumbnail: each.thumbnail,
                        title: each.title,
                        wishCount: each.wishCount,
                        commentCount: each.commentCount,
                        createdAt: each.createdAt,
                        onClicked: () async => await context.pushNamed(AppRouter.contentsDetail.name, queryParameters: {
                          'contentsId': each.id.toString(),
                          'diff': '시술별 검색',
                        }).then((value) => _pagingController.refresh()),
                      );
                    },
                    noItemsFoundIndicatorBuilder: (context) => Padding(
                      padding: EdgeInsets.only(top: 100.0.h),
                      child: Center(
                        child: NoListWidget(text: '$_primary 게시글이 없습니다.'),
                      ),
                    ),
                  ),
                  separatorBuilder: (context, index) => SizedBox(height: 20.0.h),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}