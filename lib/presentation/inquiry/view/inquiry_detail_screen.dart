import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mediport/core/component/.etc/no_list_widget.dart';
import 'package:mediport/core/component/chip/common_chip.dart';
import 'package:mediport/core/component/divider/thick_divider.dart';
import 'package:mediport/core/constant/app_color.dart';
import 'package:mediport/core/layout/default_layout.dart';
import 'package:mediport/service/inquiry/inquiry_providers.dart';

class InquiryDetailScreen extends ConsumerWidget {
  const InquiryDetailScreen({super.key, required this.inquiryId});

  final int inquiryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inquiryDetail = ref.watch(inquiryDetailProvider(inquiryId: inquiryId));
    return DefaultLayout(
        padding: EdgeInsets.zero,
        showAppBar: true,
        showBack: true,
        title: '1:1 문의 상세',
        child: inquiryDetail.when(
          data: (data) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 16.0.w, right: 16.0.w, top: 10.0.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonChip(
                          text: data.replyDate == null ? '미답변' : '답변완료',
                          textColor: Colors.white,
                          backgroundColor: data.replyDate == null ? AppColor.red500 : AppColor.primary,
                        ),
                        SizedBox(height: 10.0.h),
                        Text(
                          data.title,
                          style: TextStyle(fontSize: 20.0.sp, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 12.0.h),
                        Text(
                          DateFormat('yyyy.MM.dd').format(DateTime.parse(data.createdAt)),
                          style: TextStyle(
                            fontSize: 14.0.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColor.darkGrey300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0.h),
                  const Divider(
                    height: 0.0,
                    color: AppColor.grey500,
                  ),
                  SizedBox(height: 20.0.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                    child: Text(
                      data.content,
                      style: TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(height: 30.0.h),
                  const ThickDivider(),
                  SizedBox(height: 30.0.h),
                  /* 관리자 답변 */
                  if (data.replyDate == null)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 50.0.h),
                        child: NoListWidget(
                          text: '아직 답변이 등록되지 않았습니다.',
                          iconSrc: 'assets/icons/common/inquiry_grey@3x.png',
                        ),
                      ),
                    )
                  else ...[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.replyTitle!,
                            style: TextStyle(fontSize: 22.0.sp, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 10.0.h),
                          Text(
                            DateFormat('yyyy.MM.dd').format(DateTime.parse(data.replyDate!)),
                            style: TextStyle(fontSize: 14.0.sp, fontWeight: FontWeight.w400, color: AppColor.darkGrey300),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0.h),
                    const Divider(color: AppColor.grey500, height: 0.0),
                    SizedBox(height: 20.0.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                      child: Text(
                        data.replyContent!,
                        style: TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
          error: (error, stackTrace) => Center(child: NoListWidget(text: error.toString())),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ));
  }
}
