import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mediport/core/component/buttons/common_button.dart';
import 'package:mediport/core/enum/app_router.dart';
import 'package:mediport/core/layout/default_layout.dart';
import 'package:mediport/core/util/core_utils.dart';
import 'package:mediport/domain/model/user/res/user_res.dart';
import 'package:mediport/service/user/provider/user_providers.dart';

class MyScreen extends ConsumerWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userInfoProvider);
    return PopScope(
      onPopInvoked: (didPop) => CoreUtils.appExitWithBackButton(context),
      child: DefaultLayout(
        child: Column(
          children: [
            if (user == null)
              CommonButton(
                onPressed: () {
                  context.pushNamed(AppRouter.auth.name);
                },
                text: '임시 로그인',
              ),
            if (user is UserRes)
              CommonButton(
                onPressed: () {
                  ref.read(userLogoutProvider);
                },
                text: '임시 로그아웃',
              ),
          ],
        ),
      ),
    );
  }
}
