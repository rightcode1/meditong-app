import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mediport/core/constant/app_color.dart';

class AlertListRegisteredBoardContainer extends StatelessWidget {
  /// 알람 > 등록한 키워드에 대한 게시글 컨테이너
  const AlertListRegisteredBoardContainer({
    super.key,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  final String title;
  final String content;
  final DateTime createdAt;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14.0.sp,
            fontWeight: FontWeight.w500,
            color: AppColor.primary,
          ),
        ),
        Text(
          '"$content" 게시글이 등록되었습니다.',
          style: TextStyle(
            fontSize: 14.0.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 14.0.h),
        Text(
          DateFormat('yyyy.MM.dd').format(createdAt),
          style: TextStyle(fontSize: 12.0.sp, color: AppColor.darkGrey300),
        ),
      ],
    );
  }
}