import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mediport/core/constant/app_color.dart';
import 'package:mediport/core/util/data_utils.dart';

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
    required this.onClicked,
  });

  final CommonBoardListContainerMode mode;

  final String? thumbnail;
  final String title;
  final int wishCount;
  final int commentCount;
  final DateTime createdAt;
  final VoidCallback onClicked;

  @override
  Widget build(BuildContext context) {
    switch (mode) {
      case CommonBoardListContainerMode.smallPic:
        return InkWell(
          onTap: onClicked,
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  width: 70.0.h,
                  height: 70.0.h,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0.r), border: Border.all(color: AppColor.grey500)),
                  child: thumbnail == null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(5.0.r),
                          child: Image.asset('assets/images/common/app_logo.png'),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(5.0.r),
                          child: CachedNetworkImage(
                            imageUrl: thumbnail!,
                            fit: BoxFit.cover,
                          ),
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
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14.0.sp),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(DateFormat('yyyy.MM.dd').format(createdAt), style: Theme.of(context).textTheme.bodySmall!.copyWith()),
                          Row(
                            children: [
                              renderIconContainer(
                                  context: context,
                                  iconPath: 'assets/icons/common/wish_icon@3x.png',
                                  text: DataUtils.convertNumericIntoCommaFormatted(numberToBeFormatted: wishCount)),
                              SizedBox(width: 10.0.w),
                              renderIconContainer(
                                  context: context,
                                  iconPath: 'assets/icons/common/comment_icon@3x.png',
                                  text: DataUtils.convertNumericIntoCommaFormatted(numberToBeFormatted: commentCount)),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      case CommonBoardListContainerMode.bigPic:
        return InkWell(
          onTap: onClicked,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 150.0.h,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0.r), border: Border.all(color: AppColor.grey500)),
                child: thumbnail == null
                    ? Image.asset('assets/images/common/app_logo.png', height: 150.0.h)
                    : CachedNetworkImage(
                        imageUrl: thumbnail!,
                        width: double.infinity,
                        height: 150.0.h,
                        fit: BoxFit.cover,
                      ),
              ),
              SizedBox(height: 10.0.h),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14.0.sp),
              ),
              SizedBox(height: 6.0.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('yyyy.MM.dd').format(createdAt),
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(

                          fontWeight: FontWeight.w400,
                          color: AppColor.darkGrey300,
                        ),
                  ),
                  Row(
                    children: [
                      renderIconContainer(
                        context: context,
                          iconPath: 'assets/icons/common/wish_icon@3x.png',
                          text: DataUtils.convertNumericIntoCommaFormatted(numberToBeFormatted: wishCount)),
                      SizedBox(width: 10.0.w),
                      renderIconContainer(
                          context: context,
                          iconPath: 'assets/icons/common/comment_icon@3x.png',
                          text: DataUtils.convertNumericIntoCommaFormatted(numberToBeFormatted: commentCount)),
                    ],
                  )
                ],
              )
            ],
          ),
        );
      case CommonBoardListContainerMode.onlyText:
        return InkWell(
          onTap: onClicked,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14.0.sp),
              ),
              SizedBox(height: 6.0.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('yyyy.MM.dd').format(createdAt),
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(

                          fontWeight: FontWeight.w400,
                          color: AppColor.darkGrey300,
                        ),
                  ),
                  Row(
                    children: [
                      renderIconContainer(
                          context: context,
                          iconPath: 'assets/icons/common/wish_icon@3x.png',
                          text: DataUtils.convertNumericIntoCommaFormatted(numberToBeFormatted: wishCount)),
                      SizedBox(width: 10.0.w),
                      renderIconContainer(
                          context: context,
                          iconPath: 'assets/icons/common/comment_icon@3x.png',
                          text: DataUtils.convertNumericIntoCommaFormatted(numberToBeFormatted: commentCount)),
                    ],
                  )
                ],
              )
            ],
          ),
        );
      default:
        return SizedBox();
    }
  }

  /// 아이콘 컨테이너를 렌더링한다. (좋아요 및 댓글 컨테이너로서 사용)
  Widget renderIconContainer({required BuildContext context, required String iconPath, required String text}) {
    return Row(
      children: [
        Image.asset(iconPath, height: 18.0.h),
        SizedBox(width: 4.0.w),
        Text(text, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColor.darkGrey300)),
      ],
    );
  }
}
