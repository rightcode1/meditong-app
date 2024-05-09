import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediport/core/constant/app_color.dart';
import 'package:mediport/presentation/home/component/container/home_element_title_container.dart';

import '../../../../core/util/toast_utils.dart';
import '../container/home_element_carousel_clickable_container.dart';

class HomeTodayNewsElement extends StatelessWidget {
  /// 홈 > 오늘의 뉴스 엘리먼트
  const HomeTodayNewsElement({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 34.0.h, bottom: 40.0.h),
      color: AppColor.lightPrimary,
      child: Column(
        children: [
          HomeElementTitleContainer(
            title: '오늘의 뉴스',
            content: '오늘 최신뉴스를 소개해드립니다.',
            onAllButtonClicked: () => ToastUtils.showToast(context, toastText: '이동 - 오늘의 뉴스 전체보기'),
          ),
          CarouselSlider.builder(
            itemCount: 3,
            itemBuilder: (context, index, realIndex) => HomeElementCarouselClickableContainer(
              onPressed: () => ToastUtils.showToast(context, toastText: '이동 - 핫클립 상세'),
            ),
            options: CarouselOptions(
                height: 250.0.h,
                enableInfiniteScroll: false,
                padEnds: false,
                viewportFraction: 0.9
            ),
          ),
        ],
      ),
    );
  }
}
