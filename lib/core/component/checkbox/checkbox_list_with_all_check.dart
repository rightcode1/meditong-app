import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:collection/collection.dart';
import 'package:mediport/core/component/checkbox/common_checkbox.dart';

typedef AllCheckboxSelectedCallback = void Function(bool isAllSelected);

class CheckboxListWithAllCheck extends StatefulWidget {
  /// 전체 동의 체크박스가 포함된 체크박스 리스트
  ///
  /// * 전체 동의가 존재한다. 전체 동의 버튼 클릭 시, 하위 체크박스의 모든 상태를 True 로 변경한다.
  /// * 전체 동의 체크박스는 해제할 수 있다.
  ///  * 하위 체크박스가 모두 체크되었을 경우, 전체 동의도 체크될 수 있도록 한다.
  ///  * 전체 동의가 true 인 상태에서, 하위 체크박스 중 단 한 개라도 false 로 해제되었을 경우, 전체 동의 체크박스 또한 false 로 변경한다.
  ///  * 하위 체크박스의 제목은 List 로 받을 수 있도록한다. 이때, 각각의 체크박스에 대하여 아이디는 checkbox1, checkbox2 와 같이 처리한다.
  ///  * 하위 체크박스의 하단에는 내용이 들어갈 수 있도록 한다. RichText 로 처리하여 줄바꿈이 될 수 있도록 한다. 이때, 내용은 List 를 통해 전달받을 수 있으며, 내용이 필요 없을 경우에는 공백 또는 null 값을 받을 수 있도록 하여 조건문으로 렌더링을 방지한다. 단, 해당 값은 Optional 이며, null 일 경우 마찬가지로 렌더링하지 않는다. 단, 리스트가 존재하나 체크박스의 개수 만큼 일치하지 않을 경우, 예외를 발생시킨다.
  ///  * 체크박스가 변경될 때마다 반환하는 콜백과, 체크박스가 모두 true 인 상태인지를 반환하는 콜백을 정의한다.
  const CheckboxListWithAllCheck({
    this.renderAllCheckbox = true,
    this.renderDividerOfEachCheckbox = true,
    required this.checkboxNameList,
    this.checkboxContentList,
    required this.allCheckboxSelectedCallback,
    Key? key,
  }) : super(key: key);

  /// 전체 동의 체크박스 렌더링 여부 default: true
  final bool renderAllCheckbox;

  /// 각 체크 박스 요소에 대하여 Divider 를 렌더링 할지에 대한 여부 default: true
  final bool renderDividerOfEachCheckbox;

  /// 하위 체크박스명 String List
  ///
  /// 리스트 내의 이름 개수만큼의 체크박스를 렌더링한다.
  final List<String> checkboxNameList;

  /// 체크 박스 하위에 들어갈 텍스트 리스트
  ///
  /// nullable 이며, 만일 null 일 경우 체크박스 하위의 텍스트를 렌더링하지 않는다.
  /// 만일, 리스트가 존재하나 [checkboxNameList] 의 개수와 일치하지 않을 경우 예외를 발생시킨다.
  /// 공백 또는 null 이 들어갈 경우, 해당하는 체크박스 인덱스에 대해서는 내용을 렌더링하지 않는다.
  final List<String>? checkboxContentList;

  /// 체크박스가 전체 true 일 경우에 대한 콜백
  final AllCheckboxSelectedCallback allCheckboxSelectedCallback;

  @override
  State<CheckboxListWithAllCheck> createState() => _CheckboxListWithAllCheckState();
}

class _CheckboxListWithAllCheckState extends State<CheckboxListWithAllCheck> {
  List<String> get _checkboxNameList => widget.checkboxNameList;

  List<String>? get _checkboxContentList => widget.checkboxContentList;

  final Image _selectedCheckbox = Image.asset(
    'assets/icons/common/check_active_blue@3x.png',
    width: 22.0.h,
    height: 22.0.h,
  );
  final Image _unselectedCheckbox = Image.asset(
    'assets/icons/common/check_inactive_grey@3x.png',
    width: 22.0.h,
    height: 22.0.h,
  );

  /// 각 체크박스 요소에 대한 select 여부
  ///
  /// [_checkboxNameList] 를 통해 체크박스 렌더링 시, 해당 리스트의 index 를 활용하여 [_selectedList] 의 boolean 값을 제어한다.
  List<bool> _selectedList = [];

  /// 전체 동의 여부
  bool _isAllSelected = false;

  @override
  void initState() {
    super.initState();
    _selectedList.addAll(List.generate(_checkboxNameList.length, (index) => false));
  }

  @override
  Widget build(BuildContext context) {
    if (_checkboxContentList != null && _checkboxContentList!.length != _checkboxNameList.length) {
      throw Exception(
          'checkboxNameList 내 요소의 개수와 checkboxContentList 내 요소의 개수는 반드시 동일해야합니다.\n특정 체크박스에 대하여 하위 내용이 필요 없을 경우, 공백(\'\') 또는 null 로 채워야합니다.');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Visibility(
          maintainState: true,
          visible: widget.renderAllCheckbox,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  if (!_isAllSelected) {
                    widget.allCheckboxSelectedCallback(true);
                    setState(() {
                      _isAllSelected = true;
                      _selectedList = _selectedList.map((e) => true).toList();
                    });
                  } else {
                    widget.allCheckboxSelectedCallback(false);
                    setState(() {
                      _isAllSelected = false;
                      _selectedList = _selectedList.map((e) => false).toList();
                    });
                  }
                },
                child: Row(
                  children: [
                    CommonCheckbox(
                      selectedIcon: _selectedCheckbox,
                      unselectedIcon: _unselectedCheckbox,
                      selected: _isAllSelected,
                    ),
                    SizedBox(
                      width: 10.0.w,
                    ),
                    Text(
                      '전체동의',
                      style: TextStyle(
                        fontSize: 14.0.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0.h),
                child: widget.renderDividerOfEachCheckbox ? Divider(
                  color: Colors.grey,
                  thickness: 1.0.h,
                ) : const SizedBox(),
              ),
            ],
          ),
        ),
        ..._checkboxNameList.mapIndexed((index, eachCheckboxName) {
          return GestureDetector(
            onTap: () => setState(() {
              _selectedList[index] = !_selectedList[index];

              // 요소 체크박스에 모든 값이 true 일 경우, [_isAllSelected] 를 true 로 변경한다.
              final areCheckedTotally = _selectedList.where((element) => element == false).toList().isEmpty;
              if (areCheckedTotally) {
                setState(() {
                  _isAllSelected = true;
                });
              } else {
                setState(() {
                  _isAllSelected = false;
                });
              }

              widget.allCheckboxSelectedCallback(_isAllSelected);
            }),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    CommonCheckbox(
                      selectedIcon: _selectedCheckbox,
                      unselectedIcon: _unselectedCheckbox,
                      selected: _selectedList[index],
                    ),
                    SizedBox(
                      width: 10.0.w,
                    ),
                    Text(
                      eachCheckboxName,
                      style: TextStyle(
                        fontSize: 14.0.sp,
                      ),
                    ),
                  ],
                ),
                if (_checkboxContentList != null)
                  Padding(
                    padding: EdgeInsets.only(top: 4.0.h),
                    child: RichText(
                      text: TextSpan(
                        text: _checkboxContentList![index],
                        style: TextStyle(
                          fontSize: 10.0.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                          height: 1.5.h,
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0.h),
                  child: widget.renderDividerOfEachCheckbox ? Divider(
                    color: Colors.grey,
                    thickness: 1.0.h,
                  ) : const SizedBox(),
                ),
              ],
            ),
          );
        })
      ],
    );
  }
}
