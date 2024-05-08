import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mediport/core/component/.etc/no_list_widget.dart';
import 'package:mediport/core/component/buttons/common_button.dart';
import 'package:mediport/core/component/chip/common_chip.dart';
import 'package:mediport/core/component/divider/thick_divider.dart';
import 'package:mediport/core/component/text_fields/common_form_text_field.dart';
import 'package:mediport/core/constant/app_color.dart';
import 'package:mediport/core/exception/request_exception.dart';
import 'package:mediport/core/layout/default_layout.dart';
import 'package:mediport/core/util/toast_utils.dart';
import 'package:mediport/domain/model/contents/res/contents_res_detail.dart';
import 'package:mediport/service/contents/contents_providers.dart';

class ContentsDetailScreen extends ConsumerWidget {
  const ContentsDetailScreen({
    super.key,
    required this.contentsId,
    required this.diff,
  });

  final int contentsId;
  final String diff;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentsDetail = ref.watch(contentsDetailProvider(contentsId: contentsId));
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
        title: '$diff 상세',
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(left: 16.0.w, right: 16.0.w, bottom: 20.0.h),
          child: CommonForm.create(
            hintText: '댓글을 입력해주세요.',
            suffixIcon: Padding(
              padding: EdgeInsets.only(right: 6.0.w),
              child: SizedBox(
                width: 52.0.w,
                child: CommonButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                  text: '등록',
                ),
              ),
            ),
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () async {},
          child: contentsDetail.when(
            data: (data) {
              return SingleChildScrollView(
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
                          backgroundColor: isLike ? AppColor.red400 : AppColor.grey500,
                          onPressed: () => ref.read(contentsDetailProvider(contentsId: data.id).notifier).changeLike(),
                          textWidget: Row(
                            children: [
                              Image.asset(
                                isLike ? 'assets/icons/common/wish_icon_active_white@3x.png' :
                                'assets/icons/common/wish_icon_inactive_grey@3x.png',
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
    return Column(
      children: [],
    );
  }
}
