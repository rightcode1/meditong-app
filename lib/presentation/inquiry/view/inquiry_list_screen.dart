import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mediport/core/component/.etc/no_list_widget.dart';
import 'package:mediport/core/component/chip/common_chip.dart';
import 'package:mediport/core/constant/app_color.dart';
import 'package:mediport/core/enum/app_router.dart';
import 'package:mediport/core/layout/default_layout.dart';
import 'package:mediport/service/inquiry/inquiry_providers.dart';

class InquiryListScreen extends ConsumerWidget {
  const InquiryListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inquiryList = ref.watch(inquiryListProvider);
    return DefaultLayout(
      showAppBar: true,
      showBack: true,
      title: '1:1 문의',
      floatingActionButton: IconButton(
        onPressed: () async {
          final result = await context.pushNamed(AppRouter.inquiryRegister.name);

          if (result == true) {
            ref.invalidate(inquiryListProvider);
          }
        },
        icon: Image.asset('assets/icons/common/write_circled_primary@3x.png', height: 60.0.h),
      ),
      child: inquiryList.when(
        data: (data) {
          if (data.isEmpty) {
            return Padding(
              padding: EdgeInsets.only(top: 150.0.h),
              child: Center(
                child: NoListWidget(
                  text: '등록된 문의가 없습니다.',
                  iconSrc: 'assets/icons/common/inquiry_grey@3x.png',
                  isButton: true,
                  buttonText: '등록하기',
                  onButtonPressed: () async => await context
                      .pushNamed(AppRouter.inquiryRegister.name)
                      .then((value) => value == true ? ref.invalidate(inquiryListProvider) : null),
                ),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(inquiryListProvider),
            child: ListView.separated(
              itemBuilder: (context, index) {
                final eachInquiry = data[index];
                return InkWell(
                  onTap: () => context.pushNamed(AppRouter.inquiryDetail.name, queryParameters: {
                    'inquiryId': eachInquiry.id.toString(),
                  }),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (eachInquiry.replyDate == null)
                        CommonChip(
                          fontSize: 14.0.sp,
                          fontWeight: FontWeight.w600,
                          textColor: Colors.white,
                          backgroundColor: AppColor.red500,
                          text: '미답변',
                        ),
                      if (eachInquiry.replyDate != null)
                        CommonChip(
                          fontSize: 14.0.sp,
                          fontWeight: FontWeight.w600,
                          textColor: Colors.white,
                          backgroundColor: AppColor.primary,
                          text: '답변완료',
                        ),
                      SizedBox(height: 10.0.h),
                      Text(
                        eachInquiry.title,
                        style: TextStyle(fontSize: 14.0.sp, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 8.0.h),
                      Text(
                        DateFormat('yyyy.MM.dd').format(DateTime.parse(eachInquiry.createdAt)),
                        style: TextStyle(fontSize: 14.0.sp, fontWeight: FontWeight.w400, color: AppColor.darkGrey300),
                      )
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0.h),
                child: const Divider(
                  color: AppColor.grey500,
                  height: 0.0,
                ),
              ),
              itemCount: data.length,
            ),
          );
        },
        error: (error, stackTrace) => const Center(
          child: NoListWidget(text: '데이터를 불러오는 중 오류가 발생했습니다.'),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
