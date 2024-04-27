import 'package:meditong/core/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DefaultNoteContainer extends StatelessWidget {
  /// 유의사항 컨테이너
  ///
  /// [noteText] 를 전달받아 유의 사항을 렌더링한다.
  const DefaultNoteContainer({
    required this.noteText,
    Key? key,
  }) : super(key: key);

  final String noteText;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.grey400,
      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 14.0.h,
          ),
          Text(
            '유의사항',
            style: TextStyle(
              fontSize: 14.0.sp,
              fontWeight: FontWeight.w500,
              color: AppColor.grey400,
            ),
          ),
          SizedBox(
            height: 10.0.h,
          ),
          Text(
            noteText,
            style: TextStyle(
              fontSize: 10.0.sp,
              fontWeight: FontWeight.w400,
              color: AppColor.grey400,
            ),
          ),
          SizedBox(
            height: 36.0.h,
          ),
        ],
      ),
    );
  }
}
