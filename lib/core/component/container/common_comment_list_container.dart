import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediport/core/constant/app_color.dart';
import 'package:mediport/domain/model/contents_comment/res/contents_comment_res_list.dart';

class CommonCommentListContainer extends StatelessWidget {
  /// 댓글 컨테이너
  const CommonCommentListContainer({
    super.key,
    required this.isMine,
    required this.isReplied,
    required this.thumbnail,
    required this.username,
    required this.content,
    required this.createdAt,
    required this.isDeletedByAdmin,
    required this.onReportClicked,
    required this.onReplyClicked,
    required this.onDeleteClicked,
    required this.onUpdateClicked,
  });

  factory CommonCommentListContainer.fromModel({
    required ContentsCommentResList model,
    required bool? isMine,
    required bool isReplied,
    required VoidCallback onReportClicked,
    required VoidCallback onReplyClicked,
    required VoidCallback onDeleteClicked,
    required VoidCallback onUpdateClicked,
  }) {
    return CommonCommentListContainer(
      isMine: isMine,
      isReplied: isReplied,
      // TODO: 썸네일 연동
      thumbnail: null,
      username: model.user.name,
      content: model.content,
      createdAt: model.createdAt!,
      isDeletedByAdmin: model.isDeleted,
      onReportClicked: onReportClicked,
      onReplyClicked: onReplyClicked,
      onDeleteClicked: onDeleteClicked,
      onUpdateClicked: onUpdateClicked,
    );
  }

  /// null : 비회원
  /// false : 회원, 내가 쓴 댓글 X
  /// true : 회원, 내가 쓴 댓글 O
  final bool? isMine;

  /// 대댓글 여부
  final bool isReplied;

  final String? thumbnail;

  final String username;

  final String content;

  final String createdAt;

  final bool isDeletedByAdmin;

  final VoidCallback onReportClicked;

  final VoidCallback onReplyClicked;

  final VoidCallback onDeleteClicked;

  final VoidCallback onUpdateClicked;

  @override
  Widget build(BuildContext context) {
    // 로그인한 유저인지에 대한 플래그 (유저가 아닐 경우, 수정하기 및 답글달기 등의 버튼을 렌더링하지 않는다.)
    final isUser = isMine != null;

    final smallTextStyle = TextStyle(fontSize: 12.0.sp, fontWeight: FontWeight.w400);
    final textButtonStyle =
        TextButton.styleFrom(foregroundColor: AppColor.darkGrey300, padding: EdgeInsets.zero, visualDensity: VisualDensity.compact);

    return Padding(
      padding: isReplied ? EdgeInsets.only(left: 16.0.w, bottom: 10.0.h) : EdgeInsets.symmetric(vertical: 10.0.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          thumbnail == null
              ? Image.asset('assets/icons/common/default_profile.png', height: 36.0.h)
              : CachedNetworkImage(
                  imageUrl: thumbnail!,
                  height: 36.0.h,
                  fit: BoxFit.cover,
                ),
          SizedBox(width: 6.0.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: TextStyle(
                    fontSize: 14.0.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColor.darkGrey600,
                  ),
                ),
                SizedBox(height: 4.0.h),
                Text(
                  !isDeletedByAdmin ? content : '정책상 삭제된 댓글입니다.',
                  style: TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.w400, color: !isDeletedByAdmin ? null : AppColor.grey600),
                ),
                SizedBox(height: 4.0.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(createdAt, style: smallTextStyle.copyWith(color: AppColor.darkGrey300)),
                    Row(
                      children: [
                        if (isUser && isMine == false && !isDeletedByAdmin)
                          TextButton(
                            onPressed: onReportClicked,
                            style: textButtonStyle,
                            child: Text('신고하기', style: smallTextStyle.copyWith(color: AppColor.red400)),
                          ),
                        if (isUser && !isReplied && !isDeletedByAdmin)
                          TextButton(
                            onPressed: onReplyClicked,
                            style: textButtonStyle,
                            child: Text('답글달기', style: smallTextStyle.copyWith(color: AppColor.cyan700)),
                          ),
                        if (isUser && isMine == true && !isDeletedByAdmin) ...[
                          TextButton(
                            onPressed: onUpdateClicked,
                            style: textButtonStyle,
                            child: Text('수정하기', style: smallTextStyle.copyWith(color: AppColor.cyan700)),
                          ),
                          TextButton(
                            onPressed: onDeleteClicked,
                            style: textButtonStyle,
                            child: Text('삭제하기', style: smallTextStyle.copyWith(color: AppColor.pink700)),
                          ),
                        ],
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
  }
}
