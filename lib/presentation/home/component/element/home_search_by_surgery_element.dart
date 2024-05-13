import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediport/core/util/toast_utils.dart';
import 'package:mediport/presentation/home/component/container/home_element_title_container.dart';
import 'package:mediport/presentation/home/component/container/home_search_by_surgery_clickable_container.dart';

class HomeSearchBySurgeryElement extends StatelessWidget {
  /// 홈 > 시술별 검색
  const HomeSearchBySurgeryElement({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeElementTitleContainer(
          title: '시술별 검색',
          content: '시술을 소개해드립니다.',
          onAllButtonClicked: () => ToastUtils.showToast(context, toastText: '이동 - 시술별 검색 전체보기'),
        ),
        SizedBox(
          height: 110.0.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return HomeSearchBySurgeryClickableContainer(
                iconPath: 'assets/icons/common/inquiry_grey@3x.png',
                hashtag: '#리프팅',
                description: '탄력의 힘,',
                onPressed: () => ToastUtils.showToast(context, toastText: '이동 - 시술별 검색 상세'),
              );
            },
            separatorBuilder: (context, index) => SizedBox(width: 10.0.w),
            itemCount: 5,
          ),
        ),
      ],
    );
  }
}
