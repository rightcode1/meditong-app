import 'package:mediport/core/component/chip/common_chip.dart';
import 'package:mediport/core/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonSelectableChip extends StatelessWidget {
  /// CommonChip 을 바탕으로 한 선택 가능한 칩을 렌더링한다.
  ///
  /// [text] 를 전달받아 칩의 텍스트를 렌더링한다.
  /// [selected] 를 전달받아 칩의 선택 여부를 결정한다.
  /// [onSelected] 를 전달받아 칩 선택 시, 콜백을 반환한다.
  const CommonSelectableChip({
    required this.text,
    required this.selected,
    required this.onSelected,
    Key? key,
  }) : super(key: key);

  final String text;
  final bool selected;
  final void Function(bool selected) onSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onSelected(!selected),
      child: CommonChip(
        useBorder: true,
        text: text,
        fontSize: 14.0.sp,
        padding: EdgeInsets.symmetric(horizontal: 22.0.w, vertical: 6.0.h),
        textColor: selected ? Colors.white : const Color.fromRGBO(226, 229, 234, 1.0),
        backgroundColor: selected ? AppColor.green500 : Colors.white,
      ),
    );
  }
}
