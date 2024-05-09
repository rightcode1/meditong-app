import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediport/core/component/container/common_board_list_container.dart';
import 'package:mediport/core/util/toast_utils.dart';
import 'package:mediport/presentation/home/component/container/home_element_title_container.dart';

class HomeNewTop5Element extends StatelessWidget {
  /// 홈 스크린 내에서 사용되는 인기 기사 TOP5 엘리먼트
  const HomeNewTop5Element({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeElementTitleContainer(
          title: '인기 기사 TOP5',
          content: '인기 뉴스를 소개해드립니다.',
          onAllButtonClicked: () {
            ToastUtils.showToast(context, toastText: '이동 - 인기 기사 TOP5');
          },
        ),
        ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 16.0.w),
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return CommonBoardListContainer(
              mode: CommonBoardListContainerMode.smallPic,
              thumbnail: 'https://media.istockphoto.com/id/946264212/photo/putting-test-tubes-into-the-holder.jpg?s=612x612&w=0&k=20&c=52iqOMmfsOuDNrX5umocZXjNLgS5ARyHFUF_Ty2987k=',
              title: '중단 후 재투여도 효과, 리브리반드 + 렉라자 재증명해...',
              wishCount: 12040,
              commentCount: 3412,
              createdAt: DateTime.now(),
              onClicked: () => ToastUtils.showToast(context, toastText: '이동 - 기사 상세'),
            );
          },
          separatorBuilder: (context, index) => SizedBox(height: 20.0.h),
          itemCount: 5,
        ),
      ],
    );
  }
}
