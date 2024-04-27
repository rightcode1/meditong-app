import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditong/core/component/buttons/common_button.dart';
import 'package:meditong/core/enum/app_router.dart';
import 'package:meditong/core/layout/default_layout.dart';
import 'package:meditong/core/util/core_utils.dart';

class MyScreen extends StatelessWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) => CoreUtils.appExitWithBackButton(context),
      child: DefaultLayout(
        child: Column(
          children: [
            CommonButton(onPressed: () {
              context.pushNamed(AppRouter.auth.name);
            }, text: '임시 로그인',),
          ],
        ),
      ),
    );
  }
}
