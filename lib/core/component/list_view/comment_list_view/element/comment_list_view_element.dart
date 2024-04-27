import 'package:meditong/core/constant/app_color.dart';
import 'package:meditong/domain/model/base_comment_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 댓글 리스트 뷰의 각 댓글 컴포넌트
class CommentListViewElement extends StatelessWidget {
  /// 본인 댓글 작성 여부
  /// null 일 경우, 비로그인된 상태에서 댓글을 열람하고 있음을 의미한다.
  /// false 일 경우, 자신이 작성한 댓글이 아님을 의미한다.
  /// true 일 경우, 자신이 작성한 댓글을 의미한다.
  final bool? isMine;

  /// 댓글 작성자 썸네일
  // final String? userThumbnail;
  //
  /// 댓글 작성자명
  final String username;

  /// 댓글 내용
  final String content;

  /// 댓글 작성일
  final String createdAt;

  /// 댓글 삭제 핸들러
  final VoidCallback onDeleteBtnClicked;

  /// 댓글 수정 핸들러
  final void Function(String writtenText) onUpdateBtnClicked;

  /// 댓글 답글 작성 핸들러
  // final VoidCallback onReplyBtnClicked;

  const CommentListViewElement({
    required this.isMine,
    // this.userThumbnail,
    required this.username,
    required this.content,
    required this.createdAt,
    required this.onDeleteBtnClicked,
    required this.onUpdateBtnClicked,
    // required this.onReplyBtnClicked,
    Key? key,
  }) : super(key: key);

  factory CommentListViewElement.fromModel({
    required BaseCommentRes model,
    required bool? isMine,
    required VoidCallback onDeleteBtnClicked,
    required void Function(String writtenText) onUpdateBtnClicked,
    // required VoidCallback onReplyBtnClicked,
  }) {
    return CommentListViewElement(
      isMine: isMine,
      // userThumbnail: model.userImage,
      username: model.user.name,
      content: model.content,
      createdAt: model.createdAt,
      onDeleteBtnClicked: onDeleteBtnClicked,
      onUpdateBtnClicked: onUpdateBtnClicked,
      // onReplyBtnClicked: onReplyBtnClicked,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if (userThumbnail != null)
        //   SizedBox(
        //     width: 32.0.h,
        //     height: 32.0.h,
        //     child: ClipRRect(
        //       borderRadius: BorderRadius.circular(10.0.w),
        //       child: CachedImageWithSkeleton(
        //         imageUrl: userThumbnail!,
        //         fit: BoxFit.cover,
        //         shape: BoxShape.circle,
        //       ),
        //     ),
        //   ),
        SizedBox(
          width: 8.0.w,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: TextStyle(
                  fontSize: 12.0.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromRGBO(75, 75, 75, 1.0),
                ),
              ),
              SizedBox(
                height: 10.0.h,
              ),
              Text.rich(
                TextSpan(
                  text: content,
                  style: TextStyle(
                    fontSize: 14.0.sp,
                    color: const Color.fromRGBO(75, 75, 75, 1.0),
                  ),
                ),
              ),
              SizedBox(
                height: 6.0.h,
              ),
              Row(
                children: [
                  Text(
                    createdAt,
                    style: TextStyle(
                      fontSize: 10.0.sp,
                      color: AppColor.darkGrey400,
                    ),
                  ),
                  if (isMine != null)
                    isMine!
                        ? Padding(
                          padding: EdgeInsets.only(left: 14.0.w),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () => onUpdateBtnClicked(content),
                                child: Center(
                                  child: Text(
                                    '수정',
                                    style: TextStyle(
                                      fontSize: 10.0.sp,
                                      color: AppColor.green500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              SizedBox(width: 6.0.w),
                              InkWell(
                                onTap: onDeleteBtnClicked,
                                child: Center(
                                  child: Text(
                                    '삭제',
                                    style: TextStyle(
                                      fontSize: 10.0.sp,
                                      color: Colors.red,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        : const SizedBox(),
                        // : SizedBox(
                        //     width: 32.0.w,
                        //     height: 16.0.h,
                        //     child: InkWell(
                        //       onTap: onReplyBtnClicked,
                        //       child: Center(
                        //         child: Text(
                        //           '답글',
                        //           style: TextStyle(
                        //             fontSize: 9.0.sp,
                        //             color: PRIMARY_COLOR,
                        //           ),
                        //           textAlign: TextAlign.center,
                        //         ),
                        //       ),
                        //     ),
                        //   )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
