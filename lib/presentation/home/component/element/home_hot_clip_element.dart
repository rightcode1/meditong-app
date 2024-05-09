import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediport/core/util/toast_utils.dart';
import 'package:mediport/presentation/home/component/container/home_element_carousel_clickable_container.dart';
import 'package:mediport/presentation/home/component/container/home_element_title_container.dart';

class HomeHotClipElement extends StatefulWidget {
  const HomeHotClipElement({super.key});

  @override
  State<HomeHotClipElement> createState() => _HomeHotClipElementState();
}

class _HomeHotClipElementState extends State<HomeHotClipElement> {
  final CarouselController buttonCarouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeElementTitleContainer(
          title: 'Hot Clip',
          content: '인기있는 영상을 소개해드립니다.',
          onAllButtonClicked: () => ToastUtils.showToast(context, toastText: '이동 - 핫 클립 전체보기'),
        ),
        /* 핫 클립 캐러셀 */
        CarouselSlider.builder(
          itemCount: 3,
          itemBuilder: (context, index, realIndex) => HomeElementCarouselClickableContainer(
            onPressed: () => ToastUtils.showToast(context, toastText: '이동 - 핫클립 상세'),
          ),
          options: CarouselOptions(
            height: 250.0.h,
            enableInfiniteScroll: false,
            // enlargeCenterPage: true,
            // disableCenter: true,
            padEnds: false,
            viewportFraction: 0.9,
          ),
        ),
      ],
    );
  }
}
