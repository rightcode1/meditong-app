import 'package:mediport/core/constant/app_color.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Carousel Image Component
/// !! 높이 변경 시 반드시 Re-start 해야 정상적으로 보인다.
///
/// [height] - Component 자체 크기 (존재하지 않을 경우, imageHeight 를 따라간다.)
/// [itemHeight] - Carousel 할 위젯 height (필수)
/// [itemList] - Carousel 할 위젯 리스트 (필수)
/// [enableIndicator] - indicator widget 을 활성화 할지 여부 (기본 true)
/// [indicatorWidget] - custom indicator widget 을 사용하려는 경우 (enableIndicator 이 true 여야 보임)
/// [carouselOptions] - Carousel Options 설정
class ImageCarousel extends StatefulWidget {
  const ImageCarousel({
    super.key,
    this.height,
    required this.itemHeight,
    required this.itemList,
    this.enableIndicator = true,
    this.indicatorWidget,
    this.carouselOptions,
    this.onPageChanged,
    this.enableInfiniteScroll = true,
    this.alignment = Alignment.bottomCenter,
    this.borderRadius,
  });

  final double? height;
  final double itemHeight;
  final List<Widget> itemList;
  final bool enableIndicator;
  final Widget? indicatorWidget;
  final CarouselOptions? carouselOptions;
  final Function(int index)? onPageChanged;
  final bool enableInfiniteScroll;
  final Alignment alignment;
  final BorderRadius? borderRadius;

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final CarouselController controller = CarouselController();
  int _pageIndex = 0;

  double _height = 0.0;

  @override
  void initState() {
    if (widget.height == null) {
      _height = widget.itemHeight;
    } else {
      _height = widget.height!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(0.0),
            child: CarouselSlider.builder(
              itemCount: widget.itemList.length,
              itemBuilder: (BuildContext context, int index, int realIndex) {
                return SizedBox(
                  width: double.infinity,
                  child: widget.itemList[index],
                );
              },
              options: widget.carouselOptions ??
                  CarouselOptions(
                    height: widget.itemHeight,
                    initialPage: 0,
                    autoPlay: true,
                    viewportFraction: 1.0,
                    enableInfiniteScroll: widget.enableInfiniteScroll,
                    autoPlayAnimationDuration: const Duration(milliseconds: 300),
                    onPageChanged: (int index, CarouselPageChangedReason reason) {
                      if (widget.onPageChanged != null) widget.onPageChanged!(index);
                      setState(() {
                        _pageIndex = index;
                      });
                    },
                  ),
            ),
          ),
          if (widget.enableIndicator)
            Align(
              alignment: widget.alignment,
              child: widget.indicatorWidget ??
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: widget.itemList.mapIndexed((int index, element) {
                      return Container(
                        width: _pageIndex == index ? 10.w : 5.w,
                        height: 5.h,
                        margin: EdgeInsets.only(right: 3.w, bottom: 15.h),
                        decoration: BoxDecoration(
                          borderRadius: _pageIndex == index ? BorderRadius.circular(10.r) : null,
                          shape: _pageIndex == index ? BoxShape.rectangle : BoxShape.circle,
                          color: _pageIndex == index ? AppColor.primary : AppColor.darkGrey500,
                        ),
                      );
                    }).toList(),
                  ),
            ),
        ],
      ),
    );
  }
}