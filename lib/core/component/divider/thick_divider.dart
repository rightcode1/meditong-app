import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ThickDivider extends StatelessWidget {
  final double? height;

  const ThickDivider({
    this.height,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: 6.0.h,
      height: height ?? 6.0.h,
      color: Colors.grey[100],
    );
  }
}
