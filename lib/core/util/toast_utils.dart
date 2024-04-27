import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtils {
  static void showToast(context, {required String toastText, Duration duration = const Duration(seconds: 2)}) {
    final fToast = FToast();
    fToast.init(context);
    Widget toast = Container(
      width: 328.0.w,
      padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 12.0.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0.r),
        color: const Color.fromRGBO(38, 50, 56, 0.5),
      ),
      child: Center(
        child: Text(
          toastText,
          style: TextStyle(
            fontSize: 14.0.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ),
    );

    // 버튼이 연속으로 눌릴 시, 현재 토스트 창을 제거해버린다.
    fToast.removeCustomToast();

    fToast.showToast(
        child: toast,
        toastDuration: duration,
        positionedToastBuilder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                bottom: 20.0.h,
                child: child,
              ),
            ],
          );
        });
  }

  static void showToastNoContext({required String msg}) {
    Fluttertoast.showToast(msg: msg);
  }
}