import 'package:meditong/core/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/percent_indicator.dart';

class AppBarPercentIndicator extends StatelessWidget {
  /// 앱바 하단에서 사용하는 현재 페이지의 프로그래스를 나타내는 Percent Indicator
  ///
  /// 현재 프로그래스에 해당하는 0.0~1.0 사이 Double 타입의 [percent] 를 전달받아 Indicator 를 출력한다.
  const AppBarPercentIndicator({
    required this.percent,
    Key? key,
  }) : super(key: key);

  final double percent;

  @override
  Widget build(BuildContext context) {
    if (percent < 0.0 || percent > 100.0 ) {
      throw Exception('percent 는 0미만, 100 을 초과할 수 없습니다.');
    }

    return LinearPercentIndicator(
      padding: EdgeInsets.zero,
      percent: percent,
      progressColor: AppColor.green500,
      backgroundColor: AppColor.grey400,
      lineHeight: 2.0.h,
    );
  }
}
