import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediport/core/component/buttons/common_button.dart';
import 'package:mediport/core/constant/app_color.dart';

class NoListWidget extends StatelessWidget {
  final String text;
  final Widget? icon;
  final String? iconSrc;
  final bool isButton;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const NoListWidget({
    required this.text,
    this.icon,
    this.iconSrc,
    this.isButton = false,
    this.buttonText,
    this.onButtonPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isButton && (buttonText == null || onButtonPressed == null)) {
      throw Exception('isButton 값이 true 면 buttonText 와 onButtonPressed 는 필수 입력 값입니다');
    }

    if (icon != null && iconSrc != null) {
      throw Exception('icon 과 iconSrc 는 동시에 사용될 수 없습니다.');
    }

    return Column(
      children: [
        if (icon != null)
          icon!
        else if (iconSrc != null)
          Image.asset(
            iconSrc!,
            height: 46.0.h,
          )
        else if (icon == null && iconSrc == null)
          Image.asset(
            'assets/images/common/no_list_image_grey@3x.png',
            height: 46.0.h,
          ),
        SizedBox(height: 6.0.h),
        Text(text,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w400,
                  color: AppColor.grey600,
                )),
        if (isButton)
          Padding(
            padding: EdgeInsets.only(top: 10.0.h),
            child: SizedBox(
              width: 120.0.w,
              height: 40.0.h,
              child: CommonButton(
                text: buttonText!,
                onPressed: onButtonPressed!,
              ),
            ),
          ),
      ],
    );
  }
}
