import 'package:mediport/core/constant/app_color.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ToggleButton extends StatefulWidget {
  /// 컴포넌트로 전달받는 [contents] 중 하나를 선택할 수 있는 토글 버튼 컴포넌트
  ///
  /// 토글 버튼 내의 각 버튼 텍스트를 의미하는 [contents] 를 전달받아, 해당 개수 만큼의 토글 버튼을 렌더링한다.
  /// 토글 버튼 클릭 시, 선택된 인덱스와 선택된 버튼의 텍스트를 인자로 하는 콜백을 반환한다.
  /// [initSelectedIndex] 를 넘길 경우, 해당하는 인덱스로 자동 선택 된다. 기본값은 0이다.
  const ToggleButton({
    required this.contents,
    required this.onSelected,
    this.initSelectedIndex = 0,
    this.useAnimation = false,
    Key? key,
  }) : super(key: key);

  final List<String> contents;
  final void Function(int selectedIndex, String selectedContent) onSelected;
  final int initSelectedIndex;
  final bool useAnimation;

  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  List<String> get _contents => widget.contents;

  void Function(int, String) get _onSelected => widget.onSelected;

  int get _initialIndex => widget.initSelectedIndex;

  bool get _useAnimation => widget.useAnimation;

  late List<bool> _isSelected;

  @override
  void initState() {
    super.initState();

    _isSelected = List.generate(_contents.length, (index) => false);

    if (_initialIndex != 0) {
      _isSelected[_initialIndex] = true;
    } else {
      _isSelected[0] = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.grey400,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.0.w, vertical: 6.0.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ..._contents
                  .mapIndexed(
                    (selectedIndex, element) => Expanded(
                      child: SizedBox(
                        height: 40.0.h,
                        child: GestureDetector(
                          onTap: () {
                            _isSelected = _isSelected
                                .mapIndexed(
                                    (index, element) => selectedIndex == index)
                                .toList();
                            _onSelected(
                                selectedIndex, _contents[selectedIndex]);
                            setState(() {});
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: _useAnimation ? 300 : 0),
                            decoration: BoxDecoration(
                              color: _isSelected[selectedIndex]
                                  ? AppColor.green500
                                  : AppColor.grey400,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Center(
                              child: Text(
                                element,
                                style: TextStyle(
                                  fontSize: 14.0.sp,
                                  fontWeight: FontWeight.w500,
                                  color: _isSelected[selectedIndex]
                                      ? Colors.white
                                      : AppColor.darkGrey400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ],
          )),
    );
  }
}
