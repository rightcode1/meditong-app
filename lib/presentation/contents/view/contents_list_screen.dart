import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediport/core/component/.etc/no_list_widget.dart';
import 'package:mediport/core/component/buttons/common_button.dart';
import 'package:mediport/core/component/tabbar/common_tab_bar.dart';
import 'package:mediport/core/constant/app_color.dart';
import 'package:mediport/core/layout/default_layout.dart';
import 'package:mediport/presentation/contents/component/element/contents_home_element.dart';
import 'package:mediport/service/category/category_providers.dart';

class ContentsListScreen extends ConsumerStatefulWidget {
  /// 경영/장비 탭 리스트 스크린 (diff 로 경영 또는 장비 파라미터를 전달받아 해당하는 데이터를 조건 렌더링한다.)
  const ContentsListScreen({
    super.key,
    this.initialTab,
    required this.diff,
  });

  final String? initialTab;
  final String diff;

  @override
  ConsumerState<ContentsListScreen> createState() => _ContentsListScreenState();
}

class _ContentsListScreenState extends ConsumerState<ContentsListScreen> {
  /// 경영/장비
  String get _diff => widget.diff;

  /// 선택된 탭
  int _selectedTabIdx = 0;

  /// 선택된 하위 카테고리 인덱스
  int _selectedSubCategoryIdx = 0;

  @override
  Widget build(BuildContext context) {
    final categoryList = ref.watch(categoryListProvider(diff: _diff));
    return DefaultLayout(
      padding: EdgeInsets.zero,
      showAppBar: true,
      title: _diff,
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
                  labelPadding: EdgeInsets.symmetric(horizontal: 16.0.w),
                  onTap: (index) => setState(() {
                    _selectedTabIdx = index;
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
                            padding: EdgeInsets.symmetric(horizontal: 14.0.w, vertical: 10.0.h),
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
                          padding: EdgeInsets.symmetric(horizontal: 14.0.w, vertical: 10.0.h),
                          useBorder: _selectedSubCategoryIdx == index + 1,
                          foregroundColor: AppColor.grey300,
                          backgroundColor: _selectedSubCategoryIdx == index + 1 ? Colors.white : AppColor.grey300,
                          textColor: _selectedSubCategoryIdx == index + 1 ? AppColor.primary : AppColor.grey550,
                          text: eachSubCategory,
                          onPressed: () => setState(() {
                            _selectedSubCategoryIdx = index + 1;
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
                        _selectedSubCategoryIdx = subCategoryList.indexOf(value);
                      });
                    },
                  )
                /* 홈 이외의 카테고리일 경우에 대한 엘리먼트 */
                else
                  SizedBox(),
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
