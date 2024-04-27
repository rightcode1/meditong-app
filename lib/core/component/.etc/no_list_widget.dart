import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meditong/core/component/buttons/common_button.dart';

class NoListWidget extends StatelessWidget {
  final String text;
  final bool isButton;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const NoListWidget({
    required this.text,
    this.isButton = false,
    this.buttonText,
    this.onButtonPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(isButton && (buttonText == null || onButtonPressed == null)){
      throw Exception('isButton 값이 true 면 buttonText 와 onButtonPressed 는 필수 입력 값입니다');
    }
    return Column(
      children: [
        Image.asset(
          'assets/images/common/no_list_image_grey@3x.png',
          height: 76.0.h,
        ),
        SizedBox(height: 6.0.h),
        Text(
          text,
          style: TextStyle(
            fontSize: 14.0.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        if(isButton)
        Padding(
          padding: EdgeInsets.only(top: 10.0.h),
          child: SizedBox(
            width: 120.0.w,
            height: 40.0.h,
            child: CommonButton(
              text: buttonText!,
              fontSize: 14.0.sp,
              onPressed: onButtonPressed!,
            ),
          ),
        ),
      ],
    );
  }
}
