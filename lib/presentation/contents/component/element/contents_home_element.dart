import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediport/core/component/.etc/no_list_widget.dart';
import 'package:mediport/core/component/buttons/common_button.dart';
import 'package:mediport/core/component/container/common_board_list_container.dart';
import 'package:mediport/core/constant/app_color.dart';
import 'package:mediport/service/contents/contents_providers.dart';

class ContentsHomeElement extends ConsumerWidget {
  /// 경영/장비 탭 스크린 내에서 사용하는 홈 카테고리 엘리먼트 (diff 를 전달받아 API 조건 호출 및 렌더링 처리한다.)
  ///
  /// 장비 탭일 경우에만 영상 상단 고정이 렌더링된다.
  const ContentsHomeElement({
    super.key,
    required this.diff,
    required this.primary,
    required this.onShowAllButtonClicked
  });

  final String diff;

  /// 1차 카테고리
  final String primary;

  /// 전체보기 버튼 클릭 시 콜백
  final ValueChanged<String> onShowAllButtonClicked;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentsList = ref.watch(contentsListProvider(diff: diff, primary: primary, isHome: true));
    return contentsList.when(
      data: (data) {
        if (data.isEmpty) {
          return Center(
              child: Padding(
            padding: EdgeInsets.only(top: 150.0.h),
            child: NoListWidget(text: '등록된 $diff 게시글이 없습니다.'),
          ));
        }

        // 카테고리 별 데이터를 묶음 처리한다.
        final dataByCategory = data.groupListsBy((element) => element.category.name);

        return Expanded(
          child: RefreshIndicator(
            onRefresh: () async => ref.invalidate(contentsListProvider),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 20.0.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final eachCategoryName = dataByCategory.keys.elementAt(index);

                      // 해당 카테고리에 속한 하위 인기 게시글 데이터 (자식 컴포넌트 내 ListView 에서 사용)
                      final eachCategoryDataList = dataByCategory[eachCategoryName]!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          /* 인기 타이틀 및 전체보기 버튼 */
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '인기 $eachCategoryName',
                                style: TextStyle(fontSize: 20.0.sp, fontWeight: FontWeight.w700),
                              ),
                              CommonButton(
                                padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 4.0.h),
                                useBorder: true,
                                foregroundColor: AppColor.grey300,
                                backgroundColor: Colors.white,
                                textColor: AppColor.primary,
                                fontWeight: FontWeight.w600,
                                text: '전체보기',
                                onPressed: () => onShowAllButtonClicked(eachCategoryName),
                              ),
                            ],
                          ),
                          Text(
                            '$eachCategoryName을 소개해드립니다.',
                            style: TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.w500, color: AppColor.cyan700),
                          ),
                          SizedBox(height: 8.0.h),
                          /* 인기 게시글 */
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final eachData = eachCategoryDataList[index];
                              return CommonBoardListContainer(
                                mode: CommonBoardListContainerMode.smallPic,
                                thumbnail: eachData.thumbnail,
                                title: eachData.title,
                                wishCount: eachData.wishCount,
                                commentCount: eachData.commentCount,
                                createdAt: eachData.createdAt,
                              );
                            },
                            separatorBuilder: (context, index) => SizedBox(height: 20.0.h),
                            itemCount: eachCategoryDataList.length,
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 54.0.h),
                    itemCount: dataByCategory.keys.length,
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(data)
                  //   ],
                  // )
                ],
              ),
            ),
          ),
        );
      },
      error: (error, stackTrace) => Center(
        child: NoListWidget(text: error.toString()),
      ),
      loading: () => Padding(
        padding: EdgeInsets.only(top: 150.0.h),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
