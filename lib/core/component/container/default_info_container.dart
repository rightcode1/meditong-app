import 'package:meditong/core/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:collection/collection.dart';

class DefaultInfoContainer extends StatelessWidget {
  /// 정보를 렌더링하는 컨테이너
  /// 컨테이너 내부의 각 데이터는 [data] Map<String, String> 를 통해 렌더링 한다.
  /// 왼쪽이 key, 오른쪽이 value이다.
  ///
  /// data 를 통해 전달받은 값의 크기가 2 이상일 경우, 각 데이터를 구분하기 위한 Divider 를 렌더링하는 [showDivider] 를 전달받을 수 있다.
  /// 기본 값은 [false] 이다.
  /// 컨테이너 내에서 최상단 텍스트 하단에만 Divider 를 렌더링하는 [showDividerOnlyTop] 을 전달받을 수 있다.
  /// 단, [showDivider] 가 false 인 상태에서 [showDividerOnlyTop] 을 사용할 경우, 예외를 발생시킨다.
  /// 각 value 텍스트에 대한 색상을 정의하는 valueTextColor 를 전달받을 수 있다.
  const DefaultInfoContainer({
    required this.data,
    this.showDivider = false,
    this.showDividerOnlyTop = false,
    this.valueTextColor,
    this.leftTextWidthRatio,
    this.rightTextWidthRatio,
    super.key,
  });

  final Map<String, String> data;
  final bool showDivider;
  final bool showDividerOnlyTop;
  final Color? valueTextColor;

  /// 컨테이너 내 왼쪽 텍스트가 차지하는 비율
  final double? leftTextWidthRatio;
  /// 컨테이너 내 오른쪽 텍스트가 차지하는 비율
  final double? rightTextWidthRatio;

  @override
  Widget build(BuildContext context) {
    if (!showDivider && showDividerOnlyTop) {
      throw Exception('showDividerOnlyTop 이 true 일 때, showDivider 를 true 로 지정해주세요.');
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.grey400,
        borderRadius: BorderRadius.circular(8.0.h),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 20.0.h,
        horizontal: 14.0.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...data.entries.expandIndexed(
            (index, e) {
              return [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * (leftTextWidthRatio ?? 0.25),
                      child: Text(
                        e.key,
                        style: TextStyle(
                          fontSize: 14.0.sp,
                          fontWeight: FontWeight.w500,
                          color: showDividerOnlyTop && index == 0 ? AppColor.darkGrey300 : AppColor.darkGrey500,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * (rightTextWidthRatio ?? 0.55),
                      child: Text(
                        e.value,
                        style: TextStyle(
                          fontSize: 14.0.sp,
                          fontWeight: showDividerOnlyTop && index != 0 ? FontWeight.w500 : FontWeight.w700,
                          color: valueTextColor ?? AppColor.darkGrey300,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),

                /*
                  showDivider 및 showDividerOnlyTop 에 따라 추가적인 Divider 또는 SizedBox 를 렌더링할지에 대한 여부 정의
                 */

                /// 마지막 데이터에 대하여 추가 Divider 렌더링 방지 (index != data.length - 1)
                if (showDivider && !showDividerOnlyTop && index != data.length - 1)
                  Padding(
                    padding: EdgeInsets.only(top: 13.5.h, bottom: 12.5.h),
                    child: Divider(color: AppColor.grey500, height: 0.0, thickness: 1.0.w),
                  ),
                if (showDivider && showDividerOnlyTop && index == 0)
                  Padding(
                    padding: EdgeInsets.only(top: 13.5.h, bottom: 12.5.h),
                    child: Divider(color: AppColor.grey500, height: 0.0, thickness: 1.0.w),
                  ),

                /// 마지막 데이터에 대하여 추가 Divider 렌더링 방지 (index != data.length - 1)
                if (!showDivider && index != data.length - 1) SizedBox(height: 14.0.h),
                if (showDivider && showDividerOnlyTop && index != 0 && index != data.length - 1) SizedBox(height: 14.0.h),
              ];
            },
          ).toList()
          // ..removeLast(),
        ],
      ),
    );
  }
}
