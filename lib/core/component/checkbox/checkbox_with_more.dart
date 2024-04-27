import 'package:mediport/core/component/checkbox/common_checkbox.dart';
import 'package:mediport/core/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckboxWithMore extends StatelessWidget {
  /// 더보기 버튼을 갖는 체크박스 컴포넌트
  ///
  /// 선택 여부를 의미하는 [selected] 와 선택되었을 때의 콜백인 [onSelected] 를 전달받는다.
  /// 각 체크박스에 들어갈 텍스트인 [text] 를 전달받는다.
  /// 체크박스의 우측 버튼을 클릭하였을 경우에 대한 콜백인 [onMorePressed] 를 전달받는다.
  /// 체크박스의 제목 하단에는 서브 텍스트인 [subText] 를 넣을 수 있다.
  CheckboxWithMore({
    required this.text,
    this.subText,
    required this.selected,
    required this.onSelected,
    required this.onMorePressed,
    Key? key,
  }) : super(key: key);

  final String text;
  final String? subText;
  final bool selected;
  final void Function(bool selected) onSelected;
  final VoidCallback onMorePressed;

  final Image selectedIcon = Image.asset(
    'assets/icons/common/checkbox_active_blue@3x.png',
    height: 22.0.h,
  );
  final Image unselectedIcon = Image.asset(
    'assets/icons/common/checkbox_inactive_grey@3x.png',
    height: 22.0.h,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => onSelected(!selected),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonCheckbox(
                  selectedIcon: selectedIcon,
                  unselectedIcon: unselectedIcon,
                  selected: selected,
                ),
                SizedBox(
                  width: 6.0.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 3.0.h,
                    ),
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: 14.0.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (subText != null)
                      SizedBox(
                        height: 6.0.h,
                      ),
                    if (subText != null)
                      Text(
                        subText!,
                        style: TextStyle(
                          fontSize: 12.0.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColor.darkGrey400,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => onMorePressed(),
          child: Padding(
            padding: EdgeInsets.only(top: 3.0.h),
            child: Image.asset(
              'assets/icons/common/arrow_right_light_grey@3x.png',
              height: 18.0.h,
            ),
          ),
        ),
      ],
    );
  }
}
