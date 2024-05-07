import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mediport/core/constant/app_color.dart';

enum CommonBoardListContainerMode {
  smallPic,
  bigPic,
  onlyText,
}

class CommonBoardListContainer extends StatelessWidget {
  /// 앱 전역에서 사용되는 게시글 컨테이너
  ///
  /// mode :: 사진 작게, 사진 크게, 글만보기 등의 조건에 따라 렌더링 조건분기처리한다.
  const CommonBoardListContainer({
    super.key,
    required this.mode,
    required this.thumbnail,
    required this.title,
    required this.wishCount,
    required this.commentCount,
    required this.createdAt,
  });

  final CommonBoardListContainerMode mode;

  final String? thumbnail;
  final String title;
  final int wishCount;
  final int commentCount;
  final DateTime createdAt;

  @override
  Widget build(BuildContext context) {
    final greyTextStyle = TextStyle(
      fontSize: 12.0.sp,
      fontWeight: FontWeight.w400,
      color: AppColor.darkGrey300,
    );

    switch (mode) {
      case CommonBoardListContainerMode.smallPic:
        return IntrinsicHeight(
          child: Row(
            children: [
              thumbnail == null
                  ? Container(
                      decoration: BoxDecoration(
                        color: AppColor.grey300,
                        borderRadius: BorderRadius.circular(5.0.r),
                      ),
                      width: 70.0.h,
                      height: 70.0.h,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(5.0.r),
                      child: CachedNetworkImage(
                        width: 70.0.h,
                        height: 70.0.h,
                        imageUrl: thumbnail!,
                        fit: BoxFit.cover,
                      ),
                    ),
              SizedBox(width: 10.0.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 14.0.sp, fontWeight: FontWeight.w500),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(DateFormat('yyyy.MM.dd').format(createdAt), style: greyTextStyle),
                        Row(
                          children: [
                            renderIconContainer(iconPath: 'assets/icons/common/wish_icon@3x.png', text: wishCount.toString()),
                            SizedBox(width: 10.0.w),
                            renderIconContainer(iconPath: 'assets/icons/common/comment_icon@3x.png', text: commentCount.toString()),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        );
      case CommonBoardListContainerMode.bigPic:
        return SizedBox();
      case CommonBoardListContainerMode.onlyText:
        return SizedBox();
      default:
        return SizedBox();
    }
  }

  /// 아이콘 컨테이너를 렌더링한다. (좋아요 및 댓글 컨테이너로서 사용)
  Widget renderIconContainer({required String iconPath, required String text}) {
    return Row(
      children: [
        Image.asset(iconPath, height: 18.0.h),
        SizedBox(width: 4.0.w),
        Text(text, style: TextStyle(fontSize: 12.0.sp, fontWeight: FontWeight.w400, color: AppColor.darkGrey300)),
      ],
    );
  }
}
