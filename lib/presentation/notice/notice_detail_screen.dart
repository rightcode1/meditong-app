import 'package:mediport/core/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediport/core/component/.etc/no_list_widget.dart';
import 'package:mediport/core/layout/default_layout.dart';

import '../../service/notice/notice_providers.dart';

class NoticeDetailScreen extends ConsumerStatefulWidget {
  const NoticeDetailScreen({super.key, required this.id});

  final int id;

  @override
  ConsumerState createState() => _NoticeDetailScreenState();
}

class _NoticeDetailScreenState extends ConsumerState<NoticeDetailScreen> {
  int get _noticeId => widget.id;

  @override
  Widget build(BuildContext context) {
    final noticeDetail = ref.watch(noticeDetailProvider(noticeId: _noticeId));
    return DefaultLayout(
      title: '공지사항',
      showAppBar: true,
      showBack: true,
      padding: EdgeInsets.zero,
      child: noticeDetail.when(
        data: (data) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.only(top: 10.0.h, left: 16.w, right: 16.0.w, bottom: 20.0.h),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.w, color: AppColor.grey500))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12.h),
                    Text(
                      data.title,
                      style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500, color: Colors.black),
                    ),
                    Text(
                      data.createdAt,
                      style: TextStyle(fontSize: 14.spMin, fontWeight: FontWeight.w400, color: AppColor.darkGrey300),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.0.w),
                    child: Text(
                      data.content,
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        error: (error, stackTrace) => Padding(
          padding: EdgeInsets.only(top: 150.0.h),
          child: const Center(child: NoListWidget(text: '데이터를 불러오지 못 했습니다.')),
        ),
        loading: () => Padding(
          padding: EdgeInsets.only(top: 150.0.h),
          child: const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
