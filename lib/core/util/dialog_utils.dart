import 'package:meditong/core/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meditong/core/component/buttons/common_button.dart';

class DialogUtils {
  /// 버튼 하나 형태의 기본 다이얼로그, 형태에 맞게 적절히 변형하여 사용하거나 재정의한다. (기본 형태는 학원나우 다이얼로그)
  static Future<void> showOneButton({
    required BuildContext context,
    required String title,
    required String content,
    Widget Function(StateSetter bottomState)? contentWidget,
    required String buttonText,
    bool dismissible = true,
    required VoidCallback onButtonPressed,
  }) async {
    return showDialog<void>(
      //다이얼로그 위젯 소환
      context: context,
      barrierDismissible: dismissible,
      builder: (BuildContext context) {
        return Dialog(
          // 다이얼로그의 모서리 BorderRadius
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17.5),
          ),
          // 다이얼로그 자체에 대한 Padding, 경우에 따라 적절히 변형하여 사용한다.
          insetPadding: EdgeInsets.symmetric(horizontal: 30.0.w),
          // 다이얼로그 내용, 형태에 맞게 적절히 변형하여 사용한다.
          child: StatefulBuilder(builder: (context, bottomState) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 17.0.w, vertical: 24.0.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 24.5.h,
                      // 위젯이 있을 경우에 컨텐츠 하단 bottom padding 값을 유동적으로 변경한다.
                      bottom: contentWidget == null ? 38.0.h : 12.0.h,
                    ),
                    child: Column(
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.0.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 12.0.h,
                        ),
                        Text(
                          content,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.0.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 위젯이 null 이 아닐 경우 렌더링
                  if (contentWidget != null)
                    Padding(
                      padding: EdgeInsets.only(bottom: 39.5.h),
                      child: contentWidget(bottomState),
                    ),
                  SizedBox(
                    height: 50.0.h,
                    child: CommonButton(
                      text: buttonText,
                      onPressed: onButtonPressed,
                    ),
                  ),
                ],
              ),
            );
          },),
        );
      },
    );
  }

  /// 버튼 두 개 형태의 기본 다이얼로그, 형태에 맞게 적절히 변형하여 사용하거나 재정의한다. (기본 형태는 학원나우 다이얼로그)
  static Future<void> showTwoButton({
    required BuildContext context,
    bool dismissible = true,
    required String title,
    required String content,
    Widget Function(StateSetter bottomState)? contentWidget,
    required String leftButtonText,
    required String rightButtonText,
    required VoidCallback onLeftButtonPressed,
    required VoidCallback onRightButtonPressed,
  }) async {
    return showDialog<void>(
      //다이얼로그 위젯 소환
      context: context,
      barrierDismissible: dismissible,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17.5),
          ),
          insetPadding: EdgeInsets.symmetric(horizontal: 30.0.w),
          child: StatefulBuilder(builder: (context, bottomState) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 17.0.w, vertical: 24.0.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 24.5.h,
                      // 위젯이 있을 경우에 컨텐츠 하단 bottom padding 값을 유동적으로 변경한다.
                      bottom: contentWidget == null ? 38.0.h : 12.0.h,
                    ),
                    child: Column(
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.0.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 12.0.h,
                        ),
                        Text(
                          content,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.0.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 위젯이 null 이 아닐 경우 렌더링
                  if (contentWidget != null)
                    Padding(
                      padding: EdgeInsets.only(bottom: 39.5.h),
                      child: contentWidget(bottomState),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50.0.h,
                          child: CommonButton(
                            text: leftButtonText,
                            buttonColor: AppColor.grey600,
                            onPressed: onLeftButtonPressed,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 16.0.w,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 50.0.h,
                          child: CommonButton(
                            text: rightButtonText,
                            buttonColor: AppColor.primary,
                            onPressed: onRightButtonPressed,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },)
        );
      },
    );
  }
}
