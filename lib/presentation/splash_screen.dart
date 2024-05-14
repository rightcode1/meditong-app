import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediport/service/visitors/visitors_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediport/core/layout/default_layout.dart';

class SplashScreen extends ConsumerStatefulWidget {
  static get routeName => 'SplashScreen';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    ref.read(visitorsProvider);

    /// TODO: FCM 사용 시 주석 해제하여 사용
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   debugPrint('===> FCM Provider 내 Global Context 초기화');
    //   ref.read(firebaseUtilsProvider.notifier).setContext(rootNavigatorKey.currentContext!);
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      padding: EdgeInsets.zero,
      safeAreaTop: false,
      safeAreaBottom: false,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(81, 137, 245, 1.0),
              Color.fromRGBO(9, 78, 212, 1.0),
            ],
          ),
        ),
        child: Center(
          child: Image.asset('assets/images/splash/splash_logo.png', height: 88.0.h),
        ),
      ),
    );
  }
}
