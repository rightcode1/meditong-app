import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediport/core/constant/app_color.dart';
import 'package:mediport/core/util/data_utils.dart';

class HomeElementCarouselClickableContainer extends StatelessWidget {
  /// 각 홈 엘리먼트 (핫 클립/오늘의 뉴스) 내에서 사용되는 캐러셀 컨테이너
  const HomeElementCarouselClickableContainer({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final smallIconHeight = 18.0.h;

    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        width: 294.0.w,
        child: Stack(
          children: [
            /* 이미지 */
            ClipRRect(
              borderRadius: BorderRadius.circular(5.0.r),
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: CachedNetworkImage(
                  imageUrl:
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7f/Medical_sampling_equipment.jpg/1200px-Medical_sampling_equipment.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            /* Gradient */
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0.r),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(217, 217, 217, 0.0),
                    Colors.black,
                  ],
                ),
              ),
            ),
            /* 텍스트 */
            Positioned.fill(
              left: 10.0.w,
              bottom: 10.0.h,
              right: 10.0.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '낭만닥터',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                  ),
                  SizedBox(height: 2.0.h),
                  Text(
                    '40년 만에 새 기전 고혈압약',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                  ),
                  SizedBox(height: 6.0.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '2024.03.21',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                      ),
                      Row(
                        children: [
                          Image.asset('assets/icons/common/wish_icon_inactive_grey@3x.png', height: smallIconHeight),
                          SizedBox(width: 4.0.w),
                          Text(
                            DataUtils.convertNumericIntoCommaFormatted(numberToBeFormatted: 10),
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w400,
                              color: AppColor.darkGrey300,
                            ),
                          ),
                          SizedBox(width: 10.0.w),
                          Image.asset('assets/icons/common/comment_icon@3x.png', height: smallIconHeight),
                          SizedBox(width: 4.0.w),
                          Text(
                            DataUtils.convertNumericIntoCommaFormatted(numberToBeFormatted: 1458),
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w400,
                              color: AppColor.darkGrey300,
                            ),
                          ),
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
  }
}
