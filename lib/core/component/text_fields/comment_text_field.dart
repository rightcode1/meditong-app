import 'package:mediport/core/constant/app_color.dart';
import 'package:mediport/domain/repository/base_comment_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class CommentTextField extends ConsumerStatefulWidget {
  /// 댓글이 위치한 게시글 고유키 (ex. 수업공지일 경우 classNoticeId)
  final int contentId;

  /// 댓글 Repository
  final Provider<BaseCommentRepository> commentRepository;

  /// 댓글 작성 API 호출을 위한 body 내 프로퍼티 명 (ex. advertisementId)
  final String idPropertyName;

  final PagingController pagingController;
  
  final TextEditingController textEditingController;

  final bool isModifyingMode;

  final VoidCallback? onTap;

  final VoidCallback onCommentRegisterBtnClicked;

  final VoidCallback onCommentUpdateBtnClicked;

  final VoidCallback onModifyCloseClicked;

  /// [CommentListView] 내에서 사용되는 댓글 작성 텍스트필드 컴포넌트
  /// [CommentListView] 의 [PagingController] 를 받아온 후, 댓글 작성 시 해당 컨트롤러를 refresh 하여 [CommentListView] 를 재갱신한다.
  /// [isModifyingMode] 를 전달받아 현재 댓글이 수정중인지에 대한 여부를 정의한다.
  /// [onCommentRegisterBtnClicked] 를 전달받아 댓글 작성 시에 대한 콜백을 정의한다.
  /// [onCommentUpdateBtnClicked] 를 전달받아 댓글 수정 시에 대한 콜백을 정의한다.
  /// [onModifyCloseClicked] 를 전달받아 댓글 수정이 취소되었을 경우에 대한 콜백을 반환한다.
  const CommentTextField({
    required this.contentId,
    required this.commentRepository,
    required this.idPropertyName,
    required this.pagingController,
    required this.textEditingController,
    required this.isModifyingMode,
    this.onTap,
    required this.onCommentRegisterBtnClicked,
    required this.onCommentUpdateBtnClicked,
    required this.onModifyCloseClicked,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<CommentTextField> createState() => _CommentTextFieldState();
}

class _CommentTextFieldState extends ConsumerState<CommentTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColor.grey400))),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0.h),
        /*
          댓글 작성 텍스트 필드 및 버튼이 포함된 컨테이너
         */
        child: Column(
          children: [
            if (widget.isModifyingMode)
              Padding(
                padding: EdgeInsets.only(bottom: 4.0.h),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.0.h),
                  decoration: BoxDecoration(
                    color: AppColor.grey400,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('댓글 수정 중...'),
                      GestureDetector(
                        onTap: widget.onModifyCloseClicked,
                        child: Icon(Icons.close, color: Colors.black, size: 16.0.h,),
                      ),
                    ],
                  ),
                ),
              ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.0.w, vertical: 4.0.h),
              decoration: BoxDecoration(
                color: AppColor.grey200,
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onTap: widget.onTap,
                          controller: widget.textEditingController,
                          style: TextStyle(
                            fontSize: 14.0.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          cursorColor: AppColor.green500,
                          decoration: InputDecoration(
                            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
                            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
                            hintText: '댓글을 작성해주세요.',
                            hintStyle: TextStyle(
                              fontSize: 14.0.sp,
                              color: AppColor.darkGrey400,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      ),
                      SizedBox(
                        width: 8.0.w,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: AppColor.green500,
                        ),
                        onPressed: () {
                          final comment = widget.textEditingController.text;
                          if (comment.trim().isEmpty) {
                            return;
                          }

                          if (!widget.isModifyingMode) {
                            widget.onCommentRegisterBtnClicked();
                          } else {
                            widget.onCommentUpdateBtnClicked();
                          }
                        },
                        child: Text(
                          !widget.isModifyingMode ? '등록' : '수정',
                          style: TextStyle(
                            fontSize: 14.0.sp,
                            fontWeight: FontWeight.w500,
                            color: widget.textEditingController.text.trim().isEmpty ? AppColor.darkGrey400 : AppColor.green500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
