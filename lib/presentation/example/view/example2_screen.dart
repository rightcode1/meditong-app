import 'package:meditong/core/component/buttons/common_button.dart';
import 'package:meditong/core/enum/app_router.dart';
import 'package:meditong/core/layout/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Example2Screen extends StatelessWidget {
  const Example2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      showAppBar: true,
      title: 'Example2',
      child: Center(
        child: Column(
          children: [
            const Text('example 2'),
            CommonButton(onPressed: () => context.pushNamed(AppRouter.exampleSub.name), text: '서브 페이지 이동',),
          ],
        ),
      ),
    );
  }
}
