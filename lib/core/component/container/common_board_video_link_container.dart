import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonBoardVideoLinkContainer extends StatelessWidget {
  /// 클릭 시 비디오 링크로 이동하는 비디오 컨테이너
  const CommonBoardVideoLinkContainer({
    super.key,
    required this.thumbnail,
    required this.playTime,
  });

  final String thumbnail;

  final String playTime;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.0.h,
      child: Stack(
        children: [
          CachedNetworkImage(imageUrl: thumbnail),
        ],
      ),
    );
  }
}
