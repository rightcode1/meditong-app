import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediport/core/constant/app_color.dart';
import 'package:mediport/core/enum/app_router.dart';
import 'package:mediport/core/layout/default_layout.dart';
import 'package:mediport/core/util/toast_utils.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      showAppBar: true,
      padding: EdgeInsets.zero,
      titleWidget: Text(
        'medial treatment',
        style: TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.w700, color: AppColor.primary),
      ),
      actions: [
        IconButton(onPressed: () => ToastUtils.showToast(context, toastText: '기능 - ???'), icon: const Icon(Icons.person), visualDensity: VisualDensity.compact,),
        IconButton(onPressed: () => context.pushNamed(AppRouter.alert.name), icon: const Icon(Icons.notifications), visualDensity: VisualDensity.compact),
      ],
      child: SingleChildScrollView(
          child: Column(
        children: [],
      )),
    );
  }
}
