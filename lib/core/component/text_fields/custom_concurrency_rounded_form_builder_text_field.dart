import 'package:mediport/core/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

/// [FormBuilder] 에서 사용하기 위한 화폐 Numeric Formatter 가 적용된 TextFormField
/// 'common_form_text_field.dart 를 사용하세요. 해당 컴포넌트는 구버전입니다. 추후 업데이트 시, 삭제될 수 있습니다.'
class CustomConcurrencyRoundedFormBuilderTextField extends StatefulWidget {
  /// FormBuilder 에서 사용하기 위한 텍스트 필드의 이름
  final String name;
  final String? label;
  final String? hintText;
  final String? errorText;
  final String? helperText;
  final bool obscureText;
  final bool autofocus;
  final VoidCallback? onTab;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool enabled;
  final FocusNode? focusNode;
  final int? maxLines;
  final int? minLines;
  final String? initialValue;
  final ValueChanged<String?>? onChanged;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;

  /// 입력 텍스트 폰트 사이즈
  final double? inputTextFontSize;

  /// 기본 Border 색상
  final Color? defaultBorderColor;

  /// 필수 여부 (* 출력 여부)
  final bool isRequired;

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

  const CustomConcurrencyRoundedFormBuilderTextField({
    required this.name,
    this.label,
    this.onChanged,
    this.autofocus = false,
    this.obscureText = false,
    this.hintText,
    this.errorText,
    this.helperText,
    this.onTab,
    this.suffixIcon,
    this.prefixIcon,
    this.enabled = true,
    this.focusNode,
    this.maxLines = 1,
    this.minLines,
    this.initialValue = '0',
    this.validator,
    this.inputTextFontSize,
    this.defaultBorderColor,
    this.textStyle,
    this.hintStyle,
    this.onEditingCompleted,
    this.valueTransformer,
    this.maxLength,
    this.showCounterText = true,
    this.isRequired = false,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomConcurrencyRoundedFormBuilderTextField> createState() => _CustomConcurrencyRoundedFormBuilderTextFieldState();
}

class _CustomConcurrencyRoundedFormBuilderTextFieldState extends State<CustomConcurrencyRoundedFormBuilderTextField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    _controller.text = '0';
  }

  @override
  Widget build(BuildContext context) {
    final baseBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(11.0.r),
        borderSide: BorderSide(
          color: widget.defaultBorderColor ?? AppColor.grey400,
          width: 1.0,
        ));

    final errorIcon = Image.asset(
      'asset/icons/common/error_icon@3x.png',
      width: 16.h,
      height: 16.h,
    );
    const successIcon = Icon(Icons.check, color: AppColor.green500);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.label != null)
          Row(
            children: [
              Text(
                widget.label!,
                style: TextStyle(
                  fontSize: 14.0.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (widget.isRequired)
                Text(
                  ' *',
                  style: TextStyle(
                    fontSize: 14.0.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                )
            ],
          ),
        const SizedBox(height: 8.0),
        FormBuilderTextField(
          controller: _controller,
          maxLength: widget.maxLength,
          autovalidateMode: widget.validator != null ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
          name: widget.name,
          style: widget.textStyle ??
              TextStyle(
                fontSize: widget.inputTextFontSize ?? 14.0.sp,
                fontWeight: FontWeight.w400,
              ),
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          autofillHints: const <String>[
            AutofillHints.oneTimeCode,
          ],
          focusNode: widget.focusNode,
          onTap: widget.onTab,
          enabled: widget.enabled,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            TextInputFormatter.withFunction((oldValue, newValue) {
              if (newValue.text.isNotEmpty) {
                final onlyNumber = int.parse(newValue.text.replaceAll(',', ''));
                final parsedUsingNumericFormat = NumberFormat('###,###').format(onlyNumber);
                return TextEditingValue(
                  text: parsedUsingNumericFormat,
                  selection: TextSelection.fromPosition(TextPosition(offset: parsedUsingNumericFormat.length)),
                );
              }

              return TextEditingValue(
                text: newValue.text,
                selection: TextSelection.fromPosition(TextPosition(offset: newValue.text.length)),
              );
            })
          ],
          cursorColor: AppColor.green500,
          // 비밀번호 입력할때
          obscureText: widget.obscureText,
          autofocus: widget.autofocus,
          onChanged: (value) {
            /// onChanged 콜백이 존재할 경우, 콜백에 금액 표기인 ,을 제외한 스트링을 반환한다.
            if (value != null && widget.onChanged != null) {
              widget.onChanged!(value.isEmpty ? '0' : value.replaceAll(',', ''));
            }
            setState(() {});
          },
          decoration: InputDecoration(
            fillColor: AppColor.grey200,
            filled: true,
            contentPadding: EdgeInsets.only(left: 16.0.w, top: 19.0.h, bottom: 19.0.h),
            counterText: widget.showCounterText ? null : '',
            hintText: widget.hintText,
            errorText: widget.errorText,
            helperText: widget.helperText,
            suffixIconConstraints: const BoxConstraints(
              minHeight: 24,
              minWidth: 24,
            ),
            prefixIconConstraints: const BoxConstraints(
              minHeight: 24,
              minWidth: 24,
            ),
            prefixIcon: widget.prefixIcon != null
                ? Padding(
                    padding: EdgeInsets.only(left: 12.0.w, right: 4.0.w),
                    child: widget.prefixIcon,
                  )
                : null,
            suffixIcon: widget.suffixIcon != null
                ? Container(
                    margin: EdgeInsets.only(right: 14.5.w),
                    child: widget.suffixIcon,
                  )
                : widget.helperText != null
                    ? Container(margin: EdgeInsets.only(right: 14.5.w), child: successIcon)
                    : widget.errorText != null
                        ? Container(margin: EdgeInsets.only(right: 14.5.w), child: errorIcon)
                        : null,
            // suffixIcon: helperText != null
            //     ? Container(margin: EdgeInsets.only(right: 10.0.w) ,child: successIcon)
            //     : null,
            helperStyle: const TextStyle(
              color: AppColor.green500,
              // color: Color(0xffC9C9C9),
            ),
            hintStyle: widget.hintStyle ??
                TextStyle(
                  color: AppColor.grey400,
                  fontSize: 14.0.sp,
                ),
            // 모든 Input 상태의 기본 스타일 세팅
            border: baseBorder,
            disabledBorder: baseBorder,
            enabledBorder: baseBorder,
            focusedBorder: baseBorder.copyWith(
              borderSide: baseBorder.borderSide.copyWith(
                color: AppColor.green500,
              ),
            ),
          ),
          validator: widget.validator,
          // onChanged: widget.onChanged,
          onEditingComplete: widget.onEditingCompleted,
          valueTransformer: widget.valueTransformer ??
              (value) {
                if (value != null && value.isNotEmpty) {
                  return int.parse(value.replaceAll(',', ''));
                }
                return null;
              },
        ),
        SizedBox(height: 7.0.h,),
        // Text(
        //   '${DataUtils.convertNumericIntoCurrencyFormatted(numberToBeFormatted: _controller.text.isEmpty ? 0 : int.parse(_controller.text))}원',
        //   textAlign: TextAlign.right,
        //   style: TextStyle(
        //     fontSize: 14.0.sp,
        //     fontWeight: FontWeight.w600,
        //   ),
        // ),
      ],
    );
  }
}
