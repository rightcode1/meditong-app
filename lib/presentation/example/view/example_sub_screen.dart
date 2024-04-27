import 'package:meditong/core/layout/default_layout.dart';
import 'package:flutter/material.dart';

class ExampleSubScreen extends StatelessWidget {
  const ExampleSubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      showAppBar: true,
      showBack: true,
      title: '예제 서브 스크린',
      child: const Center(
        child: Text('하이'),
      ),
    );
  }
}
