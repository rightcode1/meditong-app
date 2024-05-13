import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediport/core/component/.etc/no_list_widget.dart';
import 'package:mediport/core/enum/app_router.dart';
import 'package:mediport/presentation/home/component/container/home_element_title_container.dart';
import 'package:mediport/presentation/home/component/container/home_search_by_surgery_clickable_container.dart';
import 'package:mediport/service/hashtag/hashtag_providers.dart';

class HomeSearchBySurgeryElement extends ConsumerWidget {
  /// 홈 > 시술별 검색
  const HomeSearchBySurgeryElement({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hashtagList = ref.watch(hashtagListProvider);
    return Column(
      children: [
        HomeElementTitleContainer(
          title: '시술별 검색',
          content: '시술을 소개해드립니다.',
          onAllButtonClicked: () => context.pushNamed(AppRouter.contents.name, queryParameters: {
            'diff': '시술',
          }),
        ),
        hashtagList.when(
          data: (data) {
            return SizedBox(
              height: 100.0.h,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final eachHashtag = data[index];
                  return HomeSearchBySurgeryClickableContainer(
                    iconPath: 'assets/icons/common/inquiry_grey@3x.png',
                    hashtag: '#${eachHashtag.content}',
                    description: '퍼블리싱',
                    // 선택된 해시태그 인덱스(initialHashtagIdx)를 통해 contentsListScreen 이동 즉시, 해당 스크린 내에서 불러온 해시태그 데이터의 인덱스에 속하는 데이터를 렌더링할 수 있도록 한다.
                    onPressed: () => context.pushNamed(AppRouter.contents.name, queryParameters: {
                      'diff': '시술',
                      'initialHashtagIdx': index.toString(),
                    }),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(width: 10.0.w),
                itemCount: data.length,
              ),
            );
          },
          error: (error, stackTrace) => Center(child: NoListWidget(text: error.toString())),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }
}
