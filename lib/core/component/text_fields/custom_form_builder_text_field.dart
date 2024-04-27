import 'package:mediport/core/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


/// [FormBuilder] 에서 사용하기 위한 TextFormField (기존 웨딩매치 프로젝트에서 가져와서 변형함)
@Deprecated('common_form_text_field.dart 를 사용하세요. 해당 컴포넌트는 구버전입니다. 추후 업데이트 시, 삭제될 수 있습니다.')
class CustomFormBuilderTextField extends StatelessWidget {
  /// FormBuilder 에서 사용하기 위한 텍스트 필드의 이름
  final String name;
  final String? hintText;
  final String? errorText;
  final String? helperText;
  final bool obscureText;
  final bool autofocus;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? onTab;
  final Widget? prefixIcon;
  final TextEditingController? controller;
  final bool enabled;
  final FocusNode? focusNode;
  final int? maxLines;
  final int? minLines;
  final String? initialValue;
  final ValueChanged<String?>? onChanged;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;

  /// 사용자가 키보드에서 완료 버튼을 클릭하였을 때
  final VoidCallback? onEditingCompleted;

  /// 각 텍스트 필드의 검증에 사용할 FormBuilderValidators 로 구성된 리스트
  final String? Function(String? value)? validator;

  /// 현재 텍스트 필드 내의 Value 가 save 되기 전에 값을 변형시킬 때 사용
  final ValueTransformer<String?>? valueTransformer;

  /// 글자 수 제한을 목적으로 사용
  final int? maxLength;

  /// 글자수 표시 여부
  final bool showCounterText;

  /// 기본 Border 색상
  final Color? defaultBorderColor;

  /// 입력 텍스트 폰트 사이즈
  final double? inputTextFontSize;

  const CustomFormBuilderTextField({
    required this.name,
    this.onChanged,
    this.autofocus = false,
    this.obscureText = false,
    this.hintText,
    this.errorText,
    this.helperText,
    this.keyboardType,
    this.inputFormatters,
    this.onTab,
    this.prefixIcon,
    this.controller,
    this.enabled = true,
    this.focusNode,
    this.maxLines = 1,
    this.minLines,
    this.initialValue,
    this.validator,
    this.textStyle,
    this.hintStyle,
    this.onEditingCompleted,
    this.valueTransformer,
    this.maxLength,
    this.showCounterText = true,
    this.defaultBorderColor,
    this.inputTextFontSize,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.5),
        borderSide: BorderSide(
          color: defaultBorderColor ?? Colors.transparent,
          width: 1.0,
        ));

    final errorIcon = Image.asset(
      'asset/images/common/icon/mark@3x.png',
      width: 24,
      height: 24,
    );
    const successIcon = Icon(Icons.check, color: Color(0xffA0E13A));
    return FormBuilderTextField(
      maxLength: maxLength,
      autovalidateMode: validator != null ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
      // controller 가 존재할 때, initialValue 가 null 이 아닐 수 없다.
      initialValue: controller != null ? null : initialValue ?? '',
      name: name,
      textAlignVertical: TextAlignVertical.center,
      style: textStyle ?? TextStyle(
        fontSize: inputTextFontSize ?? 13.0.sp,
        fontWeight: FontWeight.w400,
      ),
      maxLines: maxLines,
      minLines: minLines,
      autofillHints: const <String>[
        AutofillHints.oneTimeCode,
      ],
      focusNode: focusNode,
      controller: controller,
      onTap: onTab,
      enabled: enabled,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      cursorColor: AppColor.green500,
      // 비밀번호 입력할때
      obscureText: obscureText,
      autofocus: autofocus,
      // onChanged: onChanged,
      decoration: InputDecoration(
        counterText: showCounterText ? null : '',
        // false - 배경색 없음
        // true - 배경색 있음
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: EdgeInsets.symmetric(vertical: 16.5.h, horizontal: 17.5.w),
        hintText: hintText,
        errorText: errorText,
        helperText: helperText,
        suffixIconConstraints: const BoxConstraints(
          minHeight: 24,
          minWidth: 24,
        ),
        prefixIconConstraints: const BoxConstraints(
          minHeight: 24,
          minWidth: 24,
        ),
        prefixIcon: prefixIcon != null
            ? Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: prefixIcon,
        )
            : null,
        // suffixIcon: helperText != null
        //     ? Container(margin: EdgeInsets.only(right: 10.0.w) ,child: successIcon)
        //     : errorText != null
        //         ? Container(margin: EdgeInsets.only(right: 10.0.w), child: errorIcon)
        //         : null,
        suffixIcon: helperText != null
            ? Container(margin: EdgeInsets.only(right: 10.0.w) ,child: successIcon)
            : null,
        helperStyle: const TextStyle(
          // color: TEXT_FIELD_HELPER_TEXT_COLOR,
          color: Color(0xffC9C9C9),
        ),
        hintStyle: hintStyle ??
            TextStyle(
              color: AppColor.darkGrey400,
              fontSize: 13.0.sp,
            ),
        // 모든 Input 상태의 기본 스타일 세팅
        border: baseBorder,
        enabledBorder: baseBorder,
        focusedBorder: baseBorder.copyWith(
          borderSide: baseBorder.borderSide.copyWith(
            color: AppColor.green500,
          ),
        ),
      ),
      validator: validator,
      onChanged: onChanged,
      onEditingComplete: onEditingCompleted,
      valueTransformer: valueTransformer,
    );
  }
}
