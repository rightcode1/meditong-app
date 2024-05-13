import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mediport/core/component/.etc/no_list_widget.dart';
import 'package:mediport/core/component/buttons/common_button.dart';
import 'package:mediport/core/component/tabbar/common_tab_bar.dart';
import 'package:mediport/core/constant/app_color.dart';
import 'package:mediport/core/layout/default_layout.dart';
import 'package:mediport/core/util/toast_utils.dart';
import 'package:mediport/presentation/contents/component/element/contents_home_element.dart';
import 'package:mediport/presentation/contents/component/element/contents_sub_category_element.dart';
import 'package:mediport/presentation/contents/component/element/contents_surgery_element.dart';
import 'package:mediport/service/category/category_providers.dart';
import 'package:mediport/service/hashtag/hashtag_providers.dart';

class ContentsListScreen extends ConsumerStatefulWidget {
  /// 경영/영상/장비/메디통/시술별검색 리스트 스크린 (diff 로 경영 또는 장비 등의 파라미터를 전달받아 해당하는 데이터를 조건 렌더링한다.)
  const ContentsListScreen({
    super.key,
    this.initialHashtagIdx,
    required this.diff,
  });

  /// 시술별 검색 시에만 활용되는 해시태그 인덱스
  final int? initialHashtagIdx;
  final String diff;

  @override
  ConsumerState<ContentsListScreen> createState() => _ContentsListScreenState();
}

class _ContentsListScreenState extends ConsumerState<ContentsListScreen> {
  /// 경영/영상/장비/메디통
  String get _diff => widget.diff;

  /// 선택된 탭
  int _selectedTabIdx = 0;

  /// 선택된 하위 카테고리 인덱스
  int _selectedSubCategoryIdx = 0;

  @override
  void initState() {
    /* diff 가 시술일 경우, widget.initialHashtagIdx 가 존재할 경우 _selectedTabIdx 를 widget.initialHashtagIdx 로 값을 변경한다.
    * 이를 통해 초기 해시태그 탭 인덱스에 대한 적절한 데이터를 불러올 수 있도록 하기 위함이다.
    *  */
    if (_diff == '시술' && widget.initialHashtagIdx != null) {
      _selectedTabIdx = widget.initialHashtagIdx!;
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ContentsListScreen oldWidget) {
    if (oldWidget.diff != _diff) {
      _selectedTabIdx = 0;
      _selectedSubCategoryIdx = 0;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    /* 경영/장비/메디통 엘리먼트 렌더링 */
    return ['경영', '장비', '메디통'].contains(_diff)
        ? _renderContentsElement()
        : _diff == '영상'
            ? _renderVideoElement()
            : _renderSurgeryElement();
  }

  /// 경영/장비/메디통 관련한 위젯을 렌더링한다.
  Widget _renderContentsElement() {
    final categoryList = ref.watch(categoryListProvider(diff: _diff));
    return DefaultLayout(
      padding: EdgeInsets.zero,
      showAppBar: true,
      title: _diff,
      actions: [
        IconButton(
          onPressed: () {
            ToastUtils.showToast(context, toastText: '이동 - 검색');
          },
          icon: Image.asset('assets/icons/common/search_black@3x.png', height: 24.0.h),
        ),
      ],
      child: categoryList.when(
        data: (data) {
          // 탭 리스트
          final tabList = data.map((e) => e.primary).toSet();

          // 하위 카테고리 리스트
          final subCategoryList = data
              .whereIndexed((index, element) => element.primary == tabList.firstWhereIndexedOrNull((index, element) => index == _selectedTabIdx))
              .map((e) => e.name)
              .toList();

          return DefaultTabController(
            length: tabList.length,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /* 탭바 */
                CommonTabBar(
                  tabList: tabList
                      .map((e) => Tab(
                            text: e,
                          ))
                      .toList(),
                  labelPadding: EdgeInsets.symmetric(horizontal: 16.0.w,),
                  onTap: (index) => setState(() {
                    _selectedTabIdx = index;
                    _selectedSubCategoryIdx = 0;
                  }),
                ),
                SizedBox(height: 14.0.h),
                /* 하위 카테고리 */
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                  child: SizedBox(
                    height: 37.0.h,
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      // spacing: 14.0.w,
                      // runSpacing: 8.0.h,
                      itemBuilder: (context, index) {
                        /* 홈 카테고리 고정 */
                        if (index == 0) {
                          return CommonButton(
                            padding: EdgeInsets.symmetric(horizontal: 14.0.w),
                            useBorder: _selectedSubCategoryIdx == 0,
                            foregroundColor: AppColor.grey300,
                            backgroundColor: _selectedSubCategoryIdx == 0 ? Colors.white : AppColor.grey300,
                            textColor: _selectedSubCategoryIdx == 0 ? AppColor.primary : AppColor.grey550,
                            text: '홈',
                            onPressed: () => setState(() {
                              _selectedSubCategoryIdx = 0;
                            }),
                          );
                        }

                        final eachSubCategory = subCategoryList[index - 1];
                        return CommonButton(
                          padding: EdgeInsets.symmetric(horizontal: 14.0.w),
                          useBorder: _selectedSubCategoryIdx == index,
                          foregroundColor: AppColor.grey300,
                          backgroundColor: _selectedSubCategoryIdx == index ? Colors.white : AppColor.grey300,
                          textColor: _selectedSubCategoryIdx == index ? AppColor.primary : AppColor.grey550,
                          text: eachSubCategory,
                          onPressed: () => setState(() {
                            _selectedSubCategoryIdx = index;
                          }),
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(width: 14.0.w),
                      itemCount: subCategoryList.length + 1,
                    ),
                  ),
                ),
                /* 홈 카테고리일 경우에 대한 엘리먼트 */
                if (_selectedSubCategoryIdx == 0)
                  ContentsHomeElement(
                    diff: _diff,
                    primary: tabList.elementAt(_selectedTabIdx),
                    onShowAllButtonClicked: (value) {
                      setState(() {
                        _selectedSubCategoryIdx = subCategoryList.indexOf(value) + 1;
                      });
                    },
                  )
                /* 홈 이외의 카테고리일 경우에 대한 엘리먼트 */
                else ...[
                  SizedBox(height: 20.0.h),
                  ContentsSubCategoryElement(
                      diff: _diff, primary: tabList.elementAt(_selectedTabIdx), name: subCategoryList[_selectedSubCategoryIdx - 1]),
                ],
              ],
            ),
          );
        },
        error: (error, stackTrace) => Center(
          child: NoListWidget(text: error.toString()),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  /// 영상 엘리먼트를 렌더링한다.
  Widget _renderVideoElement() {
    return DefaultLayout(
      padding: EdgeInsets.zero,
      showAppBar: true,
      title: _diff,
      actions: [
        IconButton(
          onPressed: () {
            ToastUtils.showToast(context, toastText: '이동 - 검색');
          },
          icon: Image.asset('assets/icons/common/search_black@3x.png', height: 24.0.h),
        ),
      ],
      child: DefaultTabController(
        length: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /* 탭바 */
            // CommonTabBar(
            //   tabList: const [
            //     Tab(
            //       text: '리뷰',
            //     ),
            //     Tab(
            //       text: '경영',
            //     ),
            //     Tab(
            //       text: '매출업',
            //     ),
            //     Tab(
            //       text: '핫뉴스',
            //     ),
            //   ],
            //   labelPadding: EdgeInsets.symmetric(horizontal: 16.0.w),
            //   // onTap: (index) => setState(() {
            //   //   _selectedTabIdx = index;
            //   //   _selectedSubCategoryIdx = 0;
            //   // }),
            // ),
            SizedBox(height: 14.0.h),
            /* 홈 카테고리일 경우에 대한 엘리먼트 */
            // if (_selectedSubCategoryIdx == 0)
            //   ContentsHomeElement(
            //     diff: _diff,
            //     primary: tabList.elementAt(_selectedTabIdx),
            //     onShowAllButtonClicked: (value) {
            //       setState(() {
            //         _selectedSubCategoryIdx = subCategoryList.indexOf(value) + 1;
            //       });
            //     },
            //   )
            // /* 홈 이외의 카테고리일 경우에 대한 엘리먼트 */
            // else ...[
            //   SizedBox(height: 20.0.h),
            //   ContentsSubCategoryElement(
            //       diff: _diff, primary: tabList.elementAt(_selectedTabIdx), name: subCategoryList[_selectedSubCategoryIdx - 1]),
            // ],
          ],
        ),
      ),
    );
  }

  /// 시술 리스트 위젯을 렌더링한다.
  Widget _renderSurgeryElement() {
    final hashtagList = ref.watch(hashtagListProvider);
    return DefaultLayout(
      padding: EdgeInsets.zero,
      showAppBar: true,
      showBack: true,
      title: '시술별 검색',
      child: hashtagList.when(
        data: (data) {
          // 탭 리스트
          final tabList = data.map((e) => e.content).toSet();

          return DefaultTabController(
            length: tabList.length,
            initialIndex: widget.initialHashtagIdx ?? 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /* 탭바 */
                CommonTabBar(
                  tabList: tabList
                      .map((e) => Tab(
                            text: e,
                          ))
                      .toList(),
                  labelPadding: EdgeInsets.symmetric(horizontal: 16.0.w),
                  onTap: (index) => setState(() {
                    _selectedTabIdx = index;
                  }),
                ),
                SizedBox(height: 14.0.h),
                ContentsSurgeryElement(
                  primary: data[_selectedTabIdx].content,
                  hashtagId: data[_selectedTabIdx].id,
                ),
              ],
            ),
          );
        },
        error: (error, stackTrace) => Center(
          child: NoListWidget(text: error.toString()),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
