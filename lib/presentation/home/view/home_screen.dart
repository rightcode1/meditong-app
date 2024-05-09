import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediport/core/enum/app_router.dart';
import 'package:mediport/core/layout/default_layout.dart';
import 'package:mediport/presentation/home/component/element/home_advertisement_element.dart';
import 'package:mediport/presentation/home/component/element/home_hot_clip_element.dart';
import 'package:mediport/presentation/home/component/element/home_improve_income_element.dart';
import 'package:mediport/presentation/home/component/element/home_new_top5_element.dart';
import 'package:mediport/presentation/home/component/element/home_search_by_surgery_element.dart';
import 'package:mediport/presentation/home/component/element/home_today_news_element.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      showAppBar: true,
      padding: EdgeInsets.zero,
      titleWidget: Image.asset('assets/images/common/logo.png', height: 22.0.h),
      actions: [
        IconButton(
          onPressed: () => context.pushNamed(AppRouter.my.name),
          icon: Image.asset('assets/icons/common/my@3x.png', height: 20.0.h),
          visualDensity: VisualDensity.compact,
        ),
        IconButton(
            onPressed: () => context.pushNamed(AppRouter.alert.name),
            icon: Image.asset('assets/icons/common/alert_bell_black.png', height: 20.0.h),
            visualDensity: VisualDensity.compact),
      ],
      child: SingleChildScrollView(
          child: Column(
        children: [
          /* 광고 배너 엘리먼트 */
          const HomeAdvertisementElement(),
          /* 핫 클립 엘리먼트 */
          SizedBox(height: 20.0.h),
          const HomeHotClipElement(),
          /* 인기 기사 TOP 5 엘리먼트 */
          SizedBox(height: 60.0.h),
          const HomeNewTop5Element(),
          /* 시술별 검색 엘리먼트 */
          SizedBox(height: 60.0.h),
          const HomeSearchBySurgeryElement(),
          /* 매출을 올려라 엘리먼트 */
          SizedBox(height: 60.0.h),
          const HomeImproveIncomeElement(),
          /* 오늘의 뉴스 엘리먼트 */
          SizedBox(height: 40.0.h),
          const HomeTodayNewsElement(),
        ],
      )),
    );
  }
}
