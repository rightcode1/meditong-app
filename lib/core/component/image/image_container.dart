import 'dart:io';

import 'package:mediport/core/component/image/cached_image_with_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageContainer extends StatelessWidget {
  final String imagePath;
  final VoidCallback closeButtonPressed;
  final bool fromNetwork;

  const ImageContainer({
    required this.imagePath,
    required this.closeButtonPressed,
    this.fromNetwork = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imagePath.startsWith('http') && !fromNetwork) {
      throw Exception('네트워크를 통해 불러오는 이미지로 추측됩니다. fromNetwork 속성을 true 로 변경한 후, 다시 시도하세요.');
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0.h),
      child: Stack(
        // fit: StackFit.expand,
        children: [
          !fromNetwork
              ? Image.file(
                  File(imagePath),
                  width: 100.0.h,
                  height: 100.0.h,
                  fit: BoxFit.cover,
                )
              : SizedBox(
                  width: 100.0.h,
                  height: 100.0.h,
                  child: CachedImageWithSkeleton(imageUrl: imagePath),
                ),
          Positioned(
            top: 4.0.h,
            right: 4.0.h,
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: closeButtonPressed,
              child: Image.asset(
                'assets/icons/common/image_close_grey@3x.png',
                height: 22.0.h,
              ),
            ),
          )
        ],
      ),
    );
  }
}
