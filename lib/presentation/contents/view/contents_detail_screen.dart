import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mediport/core/component/.etc/no_list_widget.dart';
import 'package:mediport/core/component/buttons/common_button.dart';
import 'package:mediport/core/component/chip/common_chip.dart';
import 'package:mediport/core/component/container/common_comment_list_container.dart';
import 'package:mediport/core/component/divider/thick_divider.dart';
import 'package:mediport/core/component/text_fields/common_form_text_field.dart';
import 'package:mediport/core/constant/app_color.dart';
import 'package:mediport/core/exception/request_exception.dart';
import 'package:mediport/core/layout/default_layout.dart';
import 'package:mediport/core/util/toast_utils.dart';
import 'package:mediport/domain/model/contents/res/contents_res_detail.dart';
import 'package:mediport/domain/model/user/res/user_res.dart';
import 'package:mediport/service/contents/contents_providers.dart';
import 'package:mediport/service/contents_comment/contents_comment_providers.dart';
import 'package:mediport/service/user/provider/user_providers.dart';

import '../../../domain/model/contents_comment/res/contents_comment_res_list.dart';
import '../enum/contents_comment_mode.dart';

class ContentsDetailScreen extends ConsumerStatefulWidget {
  /// FIXME: ViewModel 활용한 엘리먼트로 분리 대상 1순위
  const ContentsDetailScreen({
    super.key,
    required this.contentsId,
    required this.diff,
  });

  final int contentsId;
  final String diff;

  @override
  ConsumerState<ContentsDetailScreen> createState() => _ContentsDetailScreenState();
}

class _ContentsDetailScreenState extends ConsumerState<ContentsDetailScreen> {
  final _commentTextController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  UserRes? _user;

  // 댓글란 포커스 노드
  final FocusNode _commentFocusNode = FocusNode();

  /// 현재 텍스트 입력창 모드 (수정/답글)
  ContentsCommentMode? _commentInputMode;

  /// 답글 작성 대상 아이디 (답글 등록 취소 또는 등록 시 제거)
  String? _replyingTargetUsername;

  /// 현재 답글/수정 대상 댓글 모델
  ContentsCommentResList? _targetCommentModel;

  @override
  void initState() {
    final user = ref.read(userInfoProvider);

    if (user is UserRes) {
      _user = user;
    }

    super.initState();
  }

  @override
  void dispose() {
    _commentTextController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contentsDetail = ref.watch(contentsDetailProvider(contentsId: widget.contentsId));

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        context.pop(true);
      },
      child: DefaultLayout(
        padding: EdgeInsets.zero,
        showAppBar: true,
        showBack: true,
        onBackPressed: () => context.pop(true),
        title: '${widget.diff} 상세',
        /* 댓글 입력란 */
        bottomNavigationBar: renderCommentTextField(),
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(contentsDetailProvider);
            ref.invalidate(contentsCommentProvider);
          },
          child: contentsDetail.when(
            data: (data) {
              return SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    /* 댓글을 제외한 바디 렌더링 */
                    renderBody(context, data),
                    renderComment(),
                  ],
                ),
              );
            },
            error: (error, stackTrace) => Center(
              child: NoListWidget(text: (error as RequestException).message),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }

  /// 댓글 입력창 렌더링 (bottomNavigationBar)
  Widget renderCommentTextField() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /* 댓글 답글/수정 컨테이너 */
        if (_commentInputMode == ContentsCommentMode.update || _commentInputMode == ContentsCommentMode.reply)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 5.0.h),
            color: AppColor.grey500,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _commentInputMode == ContentsCommentMode.update ? '댓글 수정 중' : '$_replyingTargetUsername님에게 답글 다는 중',
                  style: TextStyle(fontSize: 12.0.sp, fontWeight: FontWeight.w400, color: AppColor.darkGrey300),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      FocusManager.instance.primaryFocus?.unfocus();
                      _commentInputMode = null;
                      _commentTextController.clear();
                    });
                  },
                  icon: Icon(Icons.close, size: 16.0.sp),
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
        /* 텍스트 필드 */
        Padding(
          padding: EdgeInsets.only(
              left: 16.0.w,
              right: 16.0.w,
              top: 10.0.h,
              bottom: MediaQuery.viewInsetsOf(context).bottom > 0 ? MediaQuery.viewInsetsOf(context).bottom : 20.0.h),
          child: CommonForm.create(
            controller: _commentTextController,
            focusNode: _commentFocusNode,
            onTap: () => _scrollController.animateTo(_scrollController.position.maxScrollExtent,
                duration: const Duration(seconds: 1), curve: Curves.fastLinearToSlowEaseIn),
            onChanged: (controller) => setState(() {}),
            hintText: '댓글을 입력해주세요.',
            suffixIcon: Padding(
              padding: EdgeInsets.only(right: 6.0.w),
              child: SizedBox(
                width: 52.0.w,
                child: CommonButton(
                  backgroundColor: _commentTextController.text.isEmpty ? AppColor.grey500 : AppColor.lightPrimary,
                  textColor: AppColor.primary,
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    if (_commentTextController.text.isEmpty) return;

                    // 댓글을 전송한다. (등록/수정/답글 상태에 따라 다르게 분기한다.)
                    if (_commentInputMode == null) {
                      // 댓글을 등록한다.
                      ref
                          .read(contentsCommentProvider(contentsId: widget.contentsId).notifier)
                          .register(content: _commentTextController.text)
                          .then((result) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        _commentTextController.clear();
                        Future.delayed(const Duration(milliseconds: 300)).then((value) => _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastLinearToSlowEaseIn));
                        ToastUtils.showToast(context, toastText: result ? '댓글이 등록되었습니다.' : '댓글 등록 중 오류가 발생했습니다.');
                      });
                    } else if (_commentInputMode == ContentsCommentMode.update) {
                      // 댓글을 수정한다.
                      ref.read(contentsCommentProvider(contentsId: widget.contentsId).notifier).modify(commentId: _targetCommentModel!.id, content: _commentTextController.text).then((result) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        _commentTextController.clear();
                        ToastUtils.showToast(context, toastText: result ? '댓글이 수정되었습니다.' : '댓글 수정 중 오류가 발생했습니다.');
                        _commentInputMode = null;
                      });
                    } else {
                      // 답글을 등록한다.
                      ref
                          .read(contentsCommentProvider(contentsId: widget.contentsId).notifier)
                          .register(content: _commentTextController.text, contentsCommentId: _targetCommentModel!.id)
                          .then((result) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        _commentTextController.clear();
                        ToastUtils.showToast(context, toastText: result ? '답글이 등록되었습니다.' : '답글 등록 중 오류가 발생했습니다.');
                        _commentInputMode = null;
                      });
                    }
                  },
                  text: '등록',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 댓글을 제외한 항목 렌더링
  Widget renderBody(BuildContext context, ContentsResDetail data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /* 상단 (제목, 작성자, 게시일자, 조회수) */
            Padding(
              padding: EdgeInsets.only(left: 16.0.w, right: 16.0.w, top: 10.0.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: TextStyle(fontSize: 20.0.sp, fontWeight: FontWeight.w500, height: 1.2),
                  ),
                  SizedBox(height: 14.0.h),
                  // Text(
                  //   '낭만닥터 (프로퍼티 필요)',
                  //   style: TextStyle(fontSize: 14.0.sp, fontWeight: FontWeight.w600, color: AppColor.darkGrey600),
                  // ),
                  // SizedBox(height: 6.0.h),
                  Row(
                    children: [
                      Text(
                        DateFormat('yyyy.MM.dd').format(data.createdAt),
                        style: TextStyle(
                          fontSize: 14.0.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColor.darkGrey300,
                        ),
                      ),
                      SizedBox(width: 14.0.w),
                      Text(
                        '조회수 ',
                        style: TextStyle(
                          fontSize: 14.0.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColor.grey750,
                        ),
                      ),
                      Text(
                        data.viewCount.toString(),
                        style: TextStyle(
                          fontSize: 14.0.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColor.darkGrey300,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0.h),
              child: const Divider(
                color: AppColor.grey500,
                height: 0.0,
              ),
            ),
            /* 내용 / 해시태그 / 찜 */
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /* 내용 (data.contentsDetail 을 반복하며 사진 + 내용 형태로 반복 렌더링) */
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final eachContentDetail = data.contentsDetails[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (eachContentDetail.thumbnail != null) ...[
                            CachedNetworkImage(imageUrl: eachContentDetail.thumbnail!),
                            SizedBox(height: 10.0.h)
                          ],
                          Text(
                            eachContentDetail.content,
                            style: TextStyle(
                              fontSize: 16.0.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 20.0.h),
                    itemCount: data.contentsDetails.length,
                  ),
                  /* 해시태그 */
                  if (data.hashtags.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.0.h),
                      child: Wrap(
                        children: data.hashtags
                            .map(
                              (e) => CommonChip(
                            useBorder: true,
                            padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 4.0.h),
                            backgroundColor: Colors.white,
                            textColor: AppColor.primary,
                            borderRadius: BorderRadius.circular(9999),
                            text: e.content,
                          ),
                        )
                            .toList(),
                      ),
                    ),
                  /* 좋아요 (찜) */
                  Consumer(
                    builder: (context, ref, child) {
                      final isLike = ref.watch(contentsDetailProvider(contentsId: data.id).select((value) => value.value!.isLike));
                      return FittedBox(
                        child: CommonButton(
                          foregroundColor: AppColor.grey300,
                          backgroundColor: isLike ? AppColor.pink700 : AppColor.grey500,
                          onPressed: () => ref.read(contentsDetailProvider(contentsId: data.id).notifier).changeLike(),
                          textWidget: Row(
                            children: [
                              Image.asset(
                                isLike ? 'assets/icons/common/wish_icon_active_white@3x.png' : 'assets/icons/common/wish_icon_inactive_grey@3x.png',
                                height: 18.0.h,
                              ),
                              SizedBox(width: 4.0.w),
                              Text(
                                data.wishCount.toString(),
                                style: TextStyle(
                                  fontSize: 14.0.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isLike ? Colors.white : AppColor.darkGrey300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 30.0.h),
          child: const ThickDivider(),
        ),
      ],
    );
  }

  /// 댓글란 렌더링
  Widget renderComment() {
    return Consumer(
      builder: (context, ref, child) {
        final provider = contentsCommentProvider(contentsId: widget.contentsId);
        final notifier = ref.read(provider.notifier);
        final commentList = ref.watch(contentsCommentProvider(contentsId: widget.contentsId));

        return commentList.when(
          data: (data) {
            if (data.isEmpty) {
              return const Center(
                child: NoListWidget(text: '댓글이 없습니다.'),
              );
            }

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 14.0.sp, fontWeight: FontWeight.w600, color: Colors.black),
                      children: [const TextSpan(text: '댓글 '), TextSpan(text: '+${data.length}', style: const TextStyle(color: AppColor.primary))],
                    ),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(vertical: 20.0.h),
                    itemBuilder: (context, index) {
                      final eachComment = data[index];
                      return CommonCommentListContainer.fromModel(
                        model: eachComment,
                        isMine: _user == null ? null : _user!.id == eachComment.userId,
                        isReplied: eachComment.contentsCommentId != null,
                        onReportClicked: () {
                          ToastUtils.showToast(context, toastText: '기능 - 신고하기');
                        },
                        onReplyClicked: () {
                          setState(() {
                            _targetCommentModel = eachComment;
                            _replyingTargetUsername = eachComment.user.name;
                            _commentInputMode = ContentsCommentMode.reply;
                            FocusScope.of(context).requestFocus(_commentFocusNode);
                          });
                        },
                        onDeleteClicked: () => notifier
                            .remove(commentId: eachComment.id)
                            .then((result) => ToastUtils.showToast(context, toastText: result ? '댓글이 삭제되었습니다.' : '댓글 삭제 중 오류가 발생했습니다.')),
                        onUpdateClicked: () {
                          setState(() {
                            _targetCommentModel = eachComment;
                            _commentInputMode = ContentsCommentMode.update;
                            _commentTextController.text = eachComment.content;
                            FocusScope.of(context).requestFocus(_commentFocusNode);
                          });
                        },
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 0.0.h),
                    itemCount: data.length,
                  ),
                ],
              ),
            );
          },
          error: (error, stackTrace) => Center(
            child: NoListWidget(text: (error as RequestException).message),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
