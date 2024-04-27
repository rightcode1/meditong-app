import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediport/core/component/.etc/no_list_widget.dart';
import 'package:mediport/core/component/divider/thick_divider.dart';
import 'package:mediport/core/constant/app_color.dart';
import 'package:mediport/core/enum/app_router.dart';
import 'package:mediport/core/layout/default_layout.dart';
import 'package:mediport/core/util/toast_utils.dart';
import 'package:mediport/presentation/alert/component/container/alert_list_registered_board_container.dart';
import 'package:mediport/presentation/alert/component/element/alert_list_my_keyword_element.dart';
import 'package:mediport/service/alert/alert_providers.dart';

class AlertListScreen extends ConsumerWidget {
  const AlertListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alertList = ref.watch(alertProvider);
    return DefaultLayout(
      showAppBar: true,
      showBack: true,
      padding: EdgeInsets.zero,
      title: '알림',
      floatingActionButton: alertList.hasValue && alertList.value!.isEmpty
          ? IconButton(
              onPressed: () => context.pushNamed(AppRouter.alertRegister.name),
              icon: Image.asset('assets/icons/common/add_circled_primary@3x.png', height: 60.0.h))
          : null,
      child: alertList.when(
        data: (data) {
          if (data.isEmpty) {
            return Padding(
              padding: EdgeInsets.only(top: 150.0.h),
              child: const Center(
                child: NoListWidget(text: '키워드 알림이 없습니다.\n키워드를 등록하고 알림을 받아보세요.'),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AlertListMyKeywordElement(onRegisterPressed: () => context.pushNamed(AppRouter.alertRegister.name)),
              const ThickDivider(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    ToastUtils.showToast(context, toastText: '기능 - 새로고침');
                  },
                  child: ListView.separated(
                    padding: EdgeInsets.only(top: 30.0.h),
                    itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                      child: AlertListRegisteredBoardContainer(
                        title: '췌장암 (퍼블리싱)',
                        content: '췌장암 발견 (퍼블리싱)',
                        createdAt: DateTime.now(),
                      ),
                    ),
                    separatorBuilder: (context, index) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0.h),
                      child: Divider(color: AppColor.grey500, height: 0.0, thickness: 1.0.h),
                    ),
                    itemCount: 3,
                  ),
                ),
              )
            ],
          );
        },
        error: (error, stackTrace) => Padding(
          padding: EdgeInsets.only(top: 150.0.h),
          child: Center(
            child: NoListWidget(text: error.toString()),
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
