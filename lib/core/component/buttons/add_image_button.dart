import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddImageButton extends StatelessWidget {
  final VoidCallback onButtonPressed;

  /// 최대 이미지 등록 가능 수
  final int maxImageCount;

  /// 현재 이미지 등록한 개수
  final int nowImageCount;

  const AddImageButton({
    required this.onButtonPressed,
    this.maxImageCount = 1,
    this.nowImageCount = 0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onButtonPressed,
      child: Container(
        width: 100.0.w,
        height: 100.0.h,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/common/add_image_button_white@3x.png',
            ),
            fit: BoxFit.contain,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 42.0.w,
              bottom: 25.0.h,
              child: Center(
                child: Text(
                  '$nowImageCount/$maxImageCount',
                  style: TextStyle(
                    fontSize: 10.0.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
