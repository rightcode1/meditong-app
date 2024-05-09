import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediport/core/component/container/common_board_list_container.dart';
import 'package:mediport/core/util/toast_utils.dart';
import 'package:mediport/presentation/home/component/container/home_element_title_container.dart';

class HomeImproveIncomeElement extends StatelessWidget {
  const HomeImproveIncomeElement({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeElementTitleContainer(
          title: '매출을 올려라',
          content: '경영뉴스를 소개해드립니다.',
          onAllButtonClicked: () => ToastUtils.showToast(context, toastText: '이동 - 경영뉴스 전체보기'),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.0.w),
          itemBuilder: (context, index) {
            return CommonBoardListContainer(
              mode: CommonBoardListContainerMode.bigPic,
              thumbnail: 'https://media.istockphoto.com/id/946264212/photo/putting-test-tubes-into-the-holder.jpg?s=612x612&w=0&k=20&c=52iqOMmfsOuDNrX5umocZXjNLgS5ARyHFUF_Ty2987k=',
              title: '중단 후 재투여도 효과... 리브리반트 + 렉라자 증명하다',
              wishCount: 1233,
              commentCount: 48,
              createdAt: DateTime.now(),
              onClicked: () => ToastUtils.showToast(context, toastText: '이동 - 경영뉴스 상세'),
            );
          },
          separatorBuilder: (context, index) => SizedBox(height: 20.0.h),
          itemCount: 3,
        ),
      ],
    );
  }
}
