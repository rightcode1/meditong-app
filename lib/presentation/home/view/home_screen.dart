import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediport/core/constant/app_color.dart';
import 'package:mediport/core/enum/app_router.dart';
import 'package:mediport/core/layout/default_layout.dart';
import 'package:mediport/presentation/home/component/element/home_advertisement_element.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      showAppBar: true,
      padding: EdgeInsets.zero,
      titleWidget: Image.asset('assets/images/common/logo.png', height: 22.0.h),
      actions: [
        IconButton(
          onPressed: () => context.pushNamed(AppRouter.my.name),
          icon: Image.asset('assets/icons/common/my@3x.png', height: 20.0.h),
          visualDensity: VisualDensity.compact,
        ),
        IconButton(
            onPressed: () => context.pushNamed(AppRouter.alert.name),
            icon: Image.asset('assets/icons/common/alert_bell_black.png', height: 20.0.h),
            visualDensity: VisualDensity.compact),
      ],
      child: SingleChildScrollView(
          child: Column(
        children: [
          /* 광고 배너 엘리먼트 */
          const HomeAdvertisementElement(),
        ],
      )),
    );
  }
}
