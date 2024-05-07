import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediport/core/component/buttons/common_button.dart';
import 'package:mediport/core/constant/app_color.dart';
import 'package:table_calendar/table_calendar.dart';

class BottomSheetUtils {
  /// 각 바텀 시트 내에서 사용되는 타이틀 위젯을 반환한다.
  static Widget _renderTitle({
    required BuildContext context,
    String? title,
    Widget? titleWidget,
    required bool showCloseBtn,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // SizedBox(height: 30.0.h),
          if (title != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.0.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColor.darkGrey500,
                  ),
                ),
                if (showCloseBtn)
                  GestureDetector(
                    onTap: context.pop,
                    child: Icon(Icons.close, size: 24.0.sp),
                  )
              ],
            ),
          if (titleWidget != null) titleWidget,
        ],
      ),
    );
  }

  static double get _getButtonHeight => 50.0.h;

  static double get _getButtonTextSize => 14.0.sp;

  static Future<void> showNoButton({
    required BuildContext context,
    String? title,
    Widget? titleWidget,
    Widget Function(StateSetter bottomState)? contentWidget,
    EdgeInsets? contentPadding,
    bool isDismissible = true,
    bool isScrollControlled = true,
    bool enableDrag = true,
    bool showCloseBtn = true,
    bool centerTitle = false,
  }) async {
    if (title != null && titleWidget != null) {
      throw Exception('title, titleWidget 은 동시에 사용될 수 없습니다. 둘 중 하나만 사용해주세요.');
    }

    return showModalBottomSheet<void>(
      useRootNavigator: true,
      backgroundColor: Colors.white,
      context: context,
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      isScrollControlled: isScrollControlled,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0.w))),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter bottomState) {
            return GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10.0.w)),
                  color: Colors.white,
                ),
                child: Wrap(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _renderTitle(context: context, title: title, titleWidget: titleWidget, showCloseBtn: showCloseBtn),
                        Divider(
                          thickness: 1.0.h,
                          height: 0.0,
                          color: AppColor.grey400,
                        ),
                        if (contentWidget != null)
                          Padding(
                            padding: contentPadding ?? EdgeInsets.symmetric(horizontal: 16.0.w),
                            child: contentWidget(bottomState),
                          )
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  static Future<void> showOneButton({
    required BuildContext context,
    bool useRootNavigator = true,
    String? title,
    Widget? titleWidget,
    Widget Function(StateSetter bottomState)? contentWidget,
    EdgeInsets? contentPadding,
    required String buttonText,
    bool isButtonActive = true,
    VoidCallback? onButtonPressed,
    bool isDismissible = true,
    bool isScrollControlled = true,
    bool enableDrag = true,
    Color? buttonColor,
    Color? textColor,
    bool showCloseBtn = true,
  }) async {
    if (title == null && titleWidget == null) {
      throw Exception('title, titleWidget 둘 중 하나는 반드시 명세되어야합니다.');
    }

    if (title != null && titleWidget != null) {
      throw Exception('title, titleWidget 은 동시에 사용될 수 없습니다. 둘 중 하나만 사용해주세요.');
    }
    return showModalBottomSheet<void>(
      useRootNavigator: useRootNavigator,
      backgroundColor: Colors.transparent,
      context: context,
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      isScrollControlled: isScrollControlled,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter bottomState) {
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10.0.h)),
                color: Colors.white,
              ),
              child: Wrap(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _renderTitle(context: context, title: title, titleWidget: titleWidget, showCloseBtn: showCloseBtn),
                      Divider(
                        thickness: 1.0.h,
                        height: 0.0,
                        color: AppColor.grey400,
                      ),
                      if (contentWidget != null)
                        Padding(
                          padding: contentPadding ?? EdgeInsets.symmetric(horizontal: 16.0.h),
                          child: contentWidget(bottomState),
                        )
                    ],
                  ),

                  /// 하단 버튼
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 20.0.h),
                    child: SizedBox(
                      width: double.infinity,
                      height: _getButtonHeight,
                      child: CommonButton(
                        isActive: isButtonActive,
                        borderRadius: BorderRadius.circular(10.0.r),
                        elevation: 0.0,
                        text: buttonText,
                        textColor: textColor ?? Colors.white,
                        fontSize: _getButtonTextSize,
                        backgroundColor: buttonColor ?? AppColor.primary,
                        onPressed: onButtonPressed ??
                            () {
                              context.pop();
                            },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  static Future<void> showTwoButton({
    required BuildContext context,
    bool useRootNavigator = true,
    String? title,
    Widget? titleWidget,
    Widget Function(StateSetter bottomState)? contentWidget,
    EdgeInsets? contentPadding,
    required String leftButtonText,
    bool isLeftButtonActive = true,
    bool isRightButtonActive = true,
    required VoidCallback onLeftButtonPressed,
    required String rightButtonText,
    required VoidCallback onRightButtonPressed,
    bool isDismissible = true,
    bool isScrollControlled = true,
    bool enableDrag = true,
    bool showCloseBtn = false,
  }) async {
    if (title == null && titleWidget == null) {
      throw Exception('title, titleWidget 둘 중 하나는 반드시 명세되어야합니다.');
    }

    if (title != null && titleWidget != null) {
      throw Exception('title, titleWidget 은 동시에 사용될 수 없습니다. 둘 중 하나만 사용해주세요.');
    }
    return showModalBottomSheet<void>(
      useRootNavigator: useRootNavigator,
      backgroundColor: Colors.transparent,
      context: context,
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      isScrollControlled: isScrollControlled,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter bottomState) {
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10.0.h)),
                color: Colors.white,
              ),
              child: Wrap(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (showCloseBtn)
                        Padding(
                          padding: EdgeInsets.only(left: 16.0.w, right: 16.0.w, top: 16.0.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: context.pop,
                                    child: Icon(Icons.close, size: 24.0.sp),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      if (title != null)
                        Padding(
                          padding: contentPadding ?? EdgeInsets.only(left: 16.0.w, right: 16.0.w, top: showCloseBtn ? 0.0 : 40.0.h, bottom: 4.0.h),
                          child: Text(
                            title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.0.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      if (titleWidget != null) titleWidget,
                      if (contentWidget != null)
                        Padding(
                          padding: contentPadding ?? EdgeInsets.symmetric(horizontal: 16.0.w),
                          child: contentWidget(bottomState),
                        )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16.0.w, right: 16.0.w, top: 34.0.h, bottom: 20.0.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: _getButtonHeight,
                            child: CommonButton(
                              isActive: isLeftButtonActive,
                              borderRadius: BorderRadius.circular(10.0.r),
                              text: leftButtonText,
                              fontSize: _getButtonTextSize,
                              backgroundColor: AppColor.grey300,
                              textColor: AppColor.primary,
                              onPressed: onLeftButtonPressed,
                            ),
                          ),
                        ),
                        SizedBox(width: 14.0.w),
                        Expanded(
                          child: SizedBox(
                            height: _getButtonHeight,
                            child: CommonButton(
                              isActive: isRightButtonActive,
                              borderRadius: BorderRadius.circular(10.0.r),
                              text: rightButtonText,
                              fontSize: _getButtonTextSize,
                              fontWeight: FontWeight.w500,
                              backgroundColor: AppColor.primary,
                              onPressed: onRightButtonPressed,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// 캘린더를 이용한 날짜 선택 가능한 BottomSheet
  static Future<void> showDateSelectableCalendar({
    required BuildContext context,
    bool useRootNavigator = true,
    String? title,
    Widget? titleWidget,
    required String leftButtonText,
    required String rightButtonText,
    required VoidCallback onLeftButtonPressed,
    required void Function(DateTime selectedDate) onRightButtonPressed,
    bool isLeftButtonActive = true,
    bool isRightButtonActive = true,
    bool isDismissible = true,
    bool isScrollControlled = true,
    bool enableDrag = true,
    bool showCloseBtn = true,
  }) async {
    if (title == null && titleWidget == null) {
      throw Exception('title, titleWidget 둘 중 하나는 반드시 명세되어야합니다.');
    }

    if (title != null && titleWidget != null) {
      throw Exception('title, titleWidget 은 동시에 사용될 수 없습니다. 둘 중 하나만 사용해주세요.');
    }

    DateTime? selectedDate;
    return showModalBottomSheet(
      context: context,
      useRootNavigator: useRootNavigator,
      backgroundColor: Colors.transparent,
      isDismissible: isDismissible,
      isScrollControlled: isScrollControlled,
      enableDrag: enableDrag,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.75,
          child: StatefulBuilder(
            builder: (context, StateSetter bottomState) {
              return Container(
                width: 360.0.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10.0.h)),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          /// 제목
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (title != null)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        title,
                                        style: TextStyle(
                                          fontSize: 18.0.sp,
                                          fontWeight: FontWeight.w700,
                                          color: AppColor.darkGrey500,
                                        ),
                                      ),
                                      if (showCloseBtn)
                                        GestureDetector(
                                          onTap: context.pop,
                                          child: Icon(Icons.close, size: 24.0.sp),
                                        )
                                    ],
                                  ),
                                if (titleWidget != null) titleWidget,
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 1.0.h,
                            color: AppColor.grey400,
                          ),
                          TableCalendar(
                            locale: 'ko-KR',
                            focusedDay: selectedDate ?? DateTime.now(),
                            firstDay: DateTime.now(),
                            lastDay: DateTime(2099, 12, 31),
                            headerStyle: HeaderStyle(
                              // 2 Weeks formatting button 해제
                              headerMargin: EdgeInsets.zero,
                              rightChevronMargin: EdgeInsets.only(right: 170.0.w),
                              formatButtonVisible: false,
                              titleTextStyle: TextStyle(
                                fontSize: 16.0.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            calendarStyle: const CalendarStyle(
                              isTodayHighlighted: false,
                              selectedDecoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColor.green500,
                              ),
                              tablePadding: EdgeInsets.zero,
                            ),
                            onDaySelected: (selectedDay, focusedDay) {
                              bottomState(
                                () {
                                  selectedDate = selectedDay;
                                },
                              );
                            },
                            selectedDayPredicate: (day) {
                              return isSameDay(day, selectedDate);
                            },
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 20.0.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: _getButtonHeight,
                              child: CommonButton(
                                isActive: isLeftButtonActive,
                                borderRadius: BorderRadius.circular(10.0.r),
                                elevation: 0.0,
                                text: leftButtonText,
                                fontSize: _getButtonTextSize,
                                backgroundColor: AppColor.green100,
                                textColor: AppColor.green500,
                                onPressed: onLeftButtonPressed,
                              ),
                            ),
                          ),
                          SizedBox(width: 14.0.w),
                          Expanded(
                            child: SizedBox(
                              height: _getButtonHeight,
                              child: CommonButton(
                                isActive: isRightButtonActive && selectedDate != null,
                                borderRadius: BorderRadius.circular(10.0.r),
                                elevation: 0.0,
                                text: rightButtonText,
                                fontSize: _getButtonTextSize,
                                fontWeight: FontWeight.w500,
                                backgroundColor: AppColor.green500,
                                onPressed: () => onRightButtonPressed(selectedDate!),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
