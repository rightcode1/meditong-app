import 'package:mediport/core/constant/app_color.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

/// [FormBuilderTextField] 위젯을 대신해서 사용할 커스텀 위젯.
/// [FormBuilderTextField] 의 기능을 모두 포함하고 있으며, 추가적인 기능을 제공한다.
/// [TextEditingController] 를 내부적으로 자동 지원하고 있으며(외부에서 할당 가능), 이를 통해 텍스트 관리를 할 수 있다.
/// [onChanged] 를 통해 텍스트 필드의 값이 변경될 때 호출되는 콜백을 지정할 수 있다.
/// [FocusNode] 를 내부적으로 자동 지원(외부에서 할당 가능, 키보드 커스텀 액션 버튼 기본 활성화) 하고 있다. 이를 통해 단일 위젯 또한 포커스 관리를 할 수 있다.
/// [nextFocus] 키보드 커스텀 액션 버튼을 사용하여 다음 포커스를 지정할 수 있다.
/// [nextFocus] 를 사용하지 않을 경우 키보드 커스텀 액션 버튼은 키보드를 내리는 기능을 한다.
/// 연속되는 [nextFocus] 를 사용하기 위해서는 상위에서 [focusNode] 를 할당하여 사용해야 한다. (다음 focusNode 값을 모르기 때문)
/// [CommonForm.create] 를 통해 간편하게 위젯을 생성하여 사용할 수 있다.
///
class CommonForm extends StatefulWidget {
  const CommonForm({
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////// FormBuilderTextField Setting Start ////////////////////////////////

    super.key,
    required this.name,
    this.validator,
    this.onChanged,
    this.valueTransformer,
    this.enabled = true,
    this.onSaved,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.onReset,
    this.focusNode,
    this.restorationId,
    this.initialValue,
    this.readOnly = false,
    this.maxLines = 1,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection = true,
    this.maxLengthEnforcement,
    this.textAlign = TextAlign.start,
    this.autofocus = false,
    this.autocorrect = true,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.keyboardType,
    this.style,
    this.controller,
    this.textInputAction,
    this.strutStyle,
    this.textDirection,
    this.maxLength,
    this.onEditingComplete,
    this.onSubmitted,
    this.inputFormatters,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.buildCounter,
    this.expands = false,
    this.minLines,
    this.showCursor,
    this.onTap,
    this.onTapOutside,
    this.enableSuggestions = false,
    this.textAlignVertical,
    this.dragStartBehavior = DragStartBehavior.start,
    this.scrollController,
    this.scrollPhysics,
    // this.selectionWidthStyle,
    this.smartDashesType,
    this.smartQuotesType,
    // this.selectionHeightStyle,
    this.autofillHints,
    this.obscuringCharacter = '•',
    this.mouseCursor,
    // this.contextMenuBuilder,
    this.magnifierConfiguration,
    this.contentInsertionConfiguration,

    ///////////////////////////////// FormBuilderTextField Setting End /////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////

    ///////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////// Form Decoration Start ////////////////////////////////

    this.icon,
    this.iconColor,
    this.label,
    this.labelText,
    this.labelStyle,
    this.floatingLabelStyle,
    this.helperText,
    this.helperStyle,
    this.helperMaxLines,
    this.hintText,
    this.hintStyle,
    this.hintTextDirection,
    this.hintMaxLines,
    this.hintFadeDuration,
    this.error,
    this.errorText,
    this.errorStyle,
    this.errorMaxLines,
    this.floatingLabelBehavior,
    this.floatingLabelAlignment,
    this.isCollapsed,
    this.isDense,
    this.contentPadding,
    this.prefixIcon,
    this.prefixIconConstraints,
    this.prefix,
    this.prefixText,
    this.prefixStyle,
    this.prefixIconColor,
    this.suffixIcon,
    this.suffix,
    this.suffixText,
    this.suffixStyle,
    this.suffixIconColor,
    this.suffixIconConstraints,
    this.counter,
    this.counterText,
    this.counterStyle,
    this.filled,
    this.fillColor,
    this.focusColor,
    this.hoverColor,
    this.errorBorder,
    this.focusedBorder,
    this.focusedErrorBorder,
    this.disabledBorder,
    this.enabledBorder,
    this.border,
    this.decorationEnabled = true,
    this.semanticCounterText,
    this.alignLabelWithHint,
    this.constraints,

    ///////////////////////////////// Form Decoration End /////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////

    ///////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////// Custom Form Element Start //////////////////////////////

    this.nextFocus,
    this.customAction,

    /////////////////////////////// Custom Form Element End ///////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////
  });

  ////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////// FormBuilderTextField Setting Start ////////////////////////////////

  /// 텍스트 필드의 이름
  final String name;

  /// 텍스트 필드의 검증에 사용할 FormBuilderValidators 로 구성된 리스트
  final String? Function(String? value)? validator;

  /// 텍스트 필드의 값이 변경될 때 호출되는 콜백
  final Function(TextEditingController controller)? onChanged;

  /// 현재 텍스트 필드 내의 Value 가 save 되기 전에 값을 변형시킬 때 사용
  final Function(String?)? valueTransformer;

  /// 텍스트 필드의 활성화 여부
  final bool enabled;

  /// 텍스트 필드의 값이 저장될 때 호출되는 콜백
  final Function(String?)? onSaved;

  /// 텍스트 필드의 자동 검증 모드
  final AutovalidateMode? autovalidateMode;

  /// 텍스트 필드의 값이 리셋될 때 호출되는 콜백
  final Function()? onReset;

  /// 텍스트 필드의 포커스 노드
  final FocusNode? focusNode;

  /// 텍스트 필드의 복원 ID
  final String? restorationId;

  /// 텍스트 필드의 초기값
  final String? initialValue;

  /// 텍스트 필드의 읽기 전용 여부
  final bool readOnly;

  /// 텍스트 필드의 최대 라인 수
  final int? maxLines;

  /// 텍스트 필드의 비밀번호 입력 여부
  final bool obscureText;

  /// 텍스트 필드의 대문자 변환 여부
  final TextCapitalization textCapitalization;

  /// 텍스트 필드의 스크롤 패딩
  final EdgeInsets scrollPadding;

  /// 텍스트 필드의 상호 작용 선택 활성화 여부
  final bool enableInteractiveSelection;

  /// 텍스트 필드의 최대 글자 수 제한
  final MaxLengthEnforcement? maxLengthEnforcement;

  /// 텍스트 필드의 텍스트 정렬
  final TextAlign textAlign;

  /// 텍스트 필드의 자동 포커스 여부
  final bool autofocus;

  /// 텍스트 필드의 자동 수정 여부
  final bool autocorrect;

  /// 텍스트 필드의 커서 너비
  final double cursorWidth;

  /// 텍스트 필드의 커서 높이
  final double? cursorHeight;

  /// 텍스트 필드의 키보드 타입
  final TextInputType? keyboardType;

  /// 텍스트 필드의 스타일
  final TextStyle? style;

  /// 텍스트 필드의 컨트롤러
  final TextEditingController? controller;

  /// 텍스트 필드의 텍스트 입력 액션
  final TextInputAction? textInputAction;

  /// 텍스트 필드의 스트럿 스타일
  final StrutStyle? strutStyle;

  /// 텍스트 필드의 텍스트 방향
  final TextDirection? textDirection;

  /// 텍스트 필드의 최대 글자 수
  final int? maxLength;

  /// 텍스트 필드의 편집 완료 시 호출되는 콜백
  final Function()? onEditingComplete;

  /// 텍스트 필드의 제출 시 호출되는 콜백
  final Function(String?)? onSubmitted;

  /// 텍스트 필드의 입력 포매터
  final List<TextInputFormatter>? inputFormatters;

  /// 텍스트 필드의 커서 반지름
  final Radius? cursorRadius;

  /// 텍스트 필드의 커서 색상
  final Color? cursorColor;

  /// 텍스트 필드의 키보드 외형
  final Brightness? keyboardAppearance;

  /// 텍스트 필드의 카운터 빌더
  final InputCounterWidgetBuilder? buildCounter;

  /// 텍스트 필드의 확장 여부
  final bool expands;

  /// 텍스트 필드의 최소 라인 수
  final int? minLines;

  /// 텍스트 필드의 커서 표시 여부
  final bool? showCursor;

  /// 텍스트 필드의 탭 시 호출되는 콜백
  final Function()? onTap;

  /// 텍스트 필드의 외부 탭 시 호출되는 콜백
  final Function(PointerDownEvent)? onTapOutside;

  /// 텍스트 필드의 제안 활성화 여부
  final bool enableSuggestions;

  /// 텍스트 필드의 수직 정렬
  final TextAlignVertical? textAlignVertical;

  /// 텍스트 필드의 드래그 시작 동작
  final DragStartBehavior dragStartBehavior;

  /// 텍스트 필드의 스크롤 컨트롤러
  final ScrollController? scrollController;

  /// 텍스트 필드의 스크롤 물리
  final ScrollPhysics? scrollPhysics;

  /// 텍스트 필드의 선택 너비 스타일
  // final BoxWidthStyle selectionWidthStyle;

  /// 텍스트 필드의 스마트 대시 타입
  final SmartDashesType? smartDashesType;

  /// 텍스트 필드의 스마트 따옴표 타입
  final SmartQuotesType? smartQuotesType;

  /// 텍스트 필드의 선택 높이 스타일
  // final BoxHeightStyle selectionHeightStyle;

  /// 텍스트 필드의 자동 채우기 힌트
  final Iterable<String>? autofillHints;

  /// 텍스트 필드의 가려진 문자
  final String obscuringCharacter;

  /// 텍스트 필드의 마우스 커서
  final MouseCursor? mouseCursor;

  /// 텍스트 필드의 컨텍스트 메뉴 빌더
  // final Widget Function(BuildContext, EditableTextState)? contextMenuBuilder;

  /// 텍스트 필드의 확대경 구성
  final TextMagnifierConfiguration? magnifierConfiguration;

  /// 텍스트 필드의 콘텐츠 삽입 구성
  final ContentInsertionConfiguration? contentInsertionConfiguration;

  ///////////////////////////////// FormBuilderTextField Setting End /////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////// Form Decoration Start ////////////////////////////////

  /// 텍스트 필드의 아이콘
  final Widget? icon;

  /// 텍스트 필드의 아이콘 색상
  final Color? iconColor;

  /// 텍스트 필드의 라벨
  final Widget? label;

  /// 텍스트 필드의 라벨 텍스트
  final String? labelText;

  /// 텍스트 필드의 라벨 스타일
  final TextStyle? labelStyle;

  /// 텍스트 필드의 라벨 플로팅 스타일
  final TextStyle? floatingLabelStyle;

  /// 텍스트 필드의 도움말 텍스트
  final String? helperText;

  /// 텍스트 필드의 도움말 스타일
  final TextStyle? helperStyle;

  /// 텍스트 필드의 도움말 최대 라인
  final int? helperMaxLines;

  /// 텍스트 필드의 힌트 텍스트
  final String? hintText;

  /// 텍스트 필드의 힌트 스타일
  final TextStyle? hintStyle;

  /// 텍스트 필드의 힌트 텍스트 방향
  final TextDirection? hintTextDirection;

  /// 텍스트 필드의 힌트 최대 라인
  final int? hintMaxLines;

  /// 텍스트 필드의 힌트 페이드 지속 시간
  final Duration? hintFadeDuration;

  /// 텍스트 필드의 에러
  final Widget? error;

  /// 텍스트 필드의 에러 텍스트
  final String? errorText;

  /// 텍스트 필드의 에러 스타일
  final TextStyle? errorStyle;

  /// 텍스트 필드의 에러 최대 라인
  final int? errorMaxLines;

  /// 텍스트 필드의 플로팅 라벨 동작
  final FloatingLabelBehavior? floatingLabelBehavior;

  /// 텍스트 필드의 플로팅 라벨 정렬
  final FloatingLabelAlignment? floatingLabelAlignment;

  /// 텍스트 필드의 축소 여부
  final bool? isCollapsed;

  /// 텍스트 필드의 밀집 여부
  final bool? isDense;

  /// 텍스트 필드의 콘텐츠 패딩
  final EdgeInsetsGeometry? contentPadding;

  /// 텍스트 필드의 접두사 아이콘
  final Widget? prefixIcon;

  /// 텍스트 필드의 접두사 아이콘 제약
  final BoxConstraints? prefixIconConstraints;

  /// 텍스트 필드의 접두사
  final Widget? prefix;

  /// 텍스트 필드의 접두사 텍스트
  final String? prefixText;

  /// 텍스트 필드의 접두사 스타일
  final TextStyle? prefixStyle;

  /// 텍스트 필드의 접두사 아이콘 색상
  final Color? prefixIconColor;

  /// 텍스트 필드의 접미사 아이콘
  final Widget? suffixIcon;

  /// 텍스트 필드의 접미사
  final Widget? suffix;

  /// 텍스트 필드의 접미사 텍스트
  final String? suffixText;

  /// 텍스트 필드의 접미사 스타일
  final TextStyle? suffixStyle;

  /// 텍스트 필드의 접미사 아이콘 색상
  final Color? suffixIconColor;

  /// 텍스트 필드의 접미사 아이콘 제약
  final BoxConstraints? suffixIconConstraints;

  /// 텍스트 필드의 카운터
  final Widget? counter;

  /// 텍스트 필드의 카운터 텍스트
  final String? counterText;

  /// 텍스트 필드의 카운터 스타일
  final TextStyle? counterStyle;

  /// 텍스트 필드의 채움 여부
  final bool? filled;

  /// 텍스트 필드의 채움 색상
  final Color? fillColor;

  /// 텍스트 필드의 포커스 색상
  final Color? focusColor;

  /// 텍스트 필드의 호버 색상
  final Color? hoverColor;

  /// 텍스트 필드의 에러 보더
  final InputBorder? errorBorder;

  /// 텍스트 필드의 포커스 보더
  final InputBorder? focusedBorder;

  /// 텍스트 필드의 포커스 에러 보더
  final InputBorder? focusedErrorBorder;

  /// 텍스트 필드의 비활성화 보더
  final InputBorder? disabledBorder;

  /// 텍스트 필드의 활성화 보더
  final InputBorder? enabledBorder;

  /// 텍스트 필드의 보더
  final InputBorder? border;

  /// 텍스트 필드의 Decoration 활성화 (false 인 경우 helperText, errorText, counterText 가 표시되지 않음)
  final bool decorationEnabled;

  /// 텍스트 필드의 의미적 카운터 텍스트
  final String? semanticCounterText;

  /// 텍스트 필드의 힌트 라벨 정렬
  final bool? alignLabelWithHint;

  /// 텍스트 필드의 제약
  final BoxConstraints? constraints;

  ///////////////////////////////// Form Decoration End /////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////// Custom Form Element Start //////////////////////////////

  final FocusNode? nextFocus;
  final Function()? customAction;

  /////////////////////////////// Custom Form Element End ///////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////

  factory CommonForm.create({
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////// FormBuilderTextField Setting Start ////////////////////////////////
    String? name,
    String? Function(String? value)? validator,
    Function(TextEditingController controller)? onChanged,
    Function(String?)? valueTransformer,
    bool? enabled,
    Function(String?)? onSaved,
    AutovalidateMode? autovalidateMode,
    Function()? onReset,
    FocusNode? focusNode,
    String? restorationId,
    String? initialValue,
    bool? readOnly,
    int? maxLines,
    bool? obscureText,
    TextCapitalization? textCapitalization,
    EdgeInsets? scrollPadding,
    bool? enableInteractiveSelection,
    MaxLengthEnforcement? maxLengthEnforcement,
    TextAlign? textAlign,
    bool? autofocus,
    bool? autocorrect,
    double? cursorWidth,
    double? cursorHeight,
    TextInputType? keyboardType,
    TextStyle? style,
    TextEditingController? controller,
    TextInputAction? textInputAction,
    StrutStyle? strutStyle,
    TextDirection? textDirection,
    int? maxLength,
    Function()? onEditingComplete,
    Function(String?)? onSubmitted,
    List<TextInputFormatter>? inputFormatters,
    Radius? cursorRadius,
    Color? cursorColor,
    Brightness? keyboardAppearance,
    InputCounterWidgetBuilder? buildCounter,
    bool? expands,
    int? minLines,
    bool? showCursor,
    Function()? onTap,
    Function(PointerDownEvent)? onTapOutside,
    bool? enableSuggestions,
    TextAlignVertical? textAlignVertical,
    DragStartBehavior? dragStartBehavior,
    ScrollController? scrollController,
    ScrollPhysics? scrollPhysics,
    // BoxWidthStyle selectionWidthStyle,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    // BoxHeightStyle selectionHeightStyle,
    Iterable<String>? autofillHints,
    String? obscuringCharacter,
    MouseCursor? mouseCursor,
    // Widget Function(BuildContext, EditableTextState)? contextMenuBuilder,
    TextMagnifierConfiguration? magnifierConfiguration,
    ContentInsertionConfiguration? contentInsertionConfiguration,

    ///////////////////////////////// FormBuilderTextField Setting End /////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////

    ///////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////// Form Decoration Start ////////////////////////////////

    Widget? icon,
    Color? iconColor,
    Widget? label,
    String? labelText,
    TextStyle? labelStyle,
    TextStyle? floatingLabelStyle,
    String? helperText,
    TextStyle? helperStyle,
    int? helperMaxLines,
    String? hintText,
    TextStyle? hintStyle,
    TextDirection? hintTextDirection,
    int? hintMaxLines,
    Duration? hintFadeDuration,
    Widget? error,
    String? errorText,
    TextStyle? errorStyle,
    int? errorMaxLines,
    FloatingLabelBehavior? floatingLabelBehavior,
    FloatingLabelAlignment? floatingLabelAlignment,
    bool? isCollapsed,
    bool? isDense,
    EdgeInsetsGeometry? contentPadding,
    Widget? prefixIcon,
    BoxConstraints? prefixIconConstraints,
    Widget? prefix,
    String? prefixText,
    TextStyle? prefixStyle,
    Color? prefixIconColor,
    Widget? suffixIcon,
    Widget? suffix,
    String? suffixText,
    TextStyle? suffixStyle,
    Color? suffixIconColor,
    BoxConstraints? suffixIconConstraints,
    Widget? counter,
    String? counterText,
    TextStyle? counterStyle,
    bool? filled,
    Color? fillColor,
    Color? focusColor,
    Color? hoverColor,
    InputBorder? errorBorder,
    InputBorder? focusedBorder,
    InputBorder? focusedErrorBorder,
    InputBorder? disabledBorder,
    InputBorder? enabledBorder,
    InputBorder? border,
    bool? decorationEnabled,
    String? semanticCounterText,
    bool? alignLabelWithHint,
    BoxConstraints? constraints,

    ///////////////////////////////// Form Decoration End /////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////

    ///////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////// Custom Form Element Start //////////////////////////////

    FocusNode? nextFocus,
    Function()? customAction,

    /////////////////////////////// Custom Form Element End ///////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////
  }) {
    return CommonForm(
      ////////////////////////////////////////////////////////////////////////////////////////////////////
      //////////////////////////////// FormBuilderTextField Setting Start ////////////////////////////////

      name: name ?? UniqueKey().toString(),
      validator: validator,
      onChanged: onChanged,
      valueTransformer: valueTransformer,
      enabled: enabled ?? true,
      onSaved: onSaved,
      autovalidateMode: autovalidateMode ?? (validator != null ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled),
      onReset: onReset,
      focusNode: focusNode,
      restorationId: restorationId,
      initialValue: controller != null ? null : initialValue,
      readOnly: readOnly ?? false,
      maxLines: maxLines ?? 1,
      obscureText: obscureText ?? false,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      scrollPadding: scrollPadding ?? const EdgeInsets.all(20.0),
      enableInteractiveSelection: enableInteractiveSelection ?? true,
      maxLengthEnforcement: maxLengthEnforcement,
      textAlign: textAlign ?? TextAlign.start,
      autofocus: autofocus ?? false,
      autocorrect: autocorrect ?? true,
      cursorWidth: cursorWidth ?? 2.0,
      cursorHeight: cursorHeight,
      keyboardType: keyboardType,
      style: style ?? TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
      controller: controller,
      textInputAction: textInputAction,
      strutStyle: strutStyle,
      textDirection: textDirection,
      maxLength: maxLength,
      onEditingComplete: onEditingComplete,
      onSubmitted: onSubmitted,
      inputFormatters: inputFormatters,
      cursorRadius: cursorRadius,
      cursorColor: cursorColor ?? AppColor.primary,
      keyboardAppearance: keyboardAppearance,
      buildCounter: buildCounter,
      expands: expands ?? false,
      minLines: minLines,
      showCursor: showCursor,
      onTap: onTap,
      onTapOutside: onTapOutside,
      enableSuggestions: enableSuggestions ?? false,
      textAlignVertical: textAlignVertical ?? TextAlignVertical.center,
      dragStartBehavior: dragStartBehavior ?? DragStartBehavior.start,
      scrollController: scrollController,
      scrollPhysics: scrollPhysics,
      // selectionWidthStyle: selectionWidthStyle,
      smartDashesType: smartDashesType,
      smartQuotesType: smartQuotesType,
      // selectionHeightStyle: selectionHeightStyle,
      autofillHints: autofillHints ?? const <String>[AutofillHints.oneTimeCode],
      obscuringCharacter: obscuringCharacter ?? '•',
      mouseCursor: mouseCursor,
      // contextMenuBuilder: contextMenuBuilder,
      magnifierConfiguration: magnifierConfiguration,
      contentInsertionConfiguration: contentInsertionConfiguration,

      ///////////////////////////////// FormBuilderTextField Setting End /////////////////////////////////
      ////////////////////////////////////////////////////////////////////////////////////////////////////

      ///////////////////////////////////////////////////////////////////////////////////////
      //////////////////////////////// Form Decoration Start ////////////////////////////////

      icon: icon,
      iconColor: iconColor,
      label: label,
      labelText: labelText,
      labelStyle: labelStyle,
      floatingLabelStyle: floatingLabelStyle,
      helperText: helperText,
      helperStyle: helperStyle ?? TextStyle(fontSize: 12.spMin, fontWeight: FontWeight.w400, color: AppColor.primary),
      helperMaxLines: helperMaxLines,
      hintText: hintText,
      hintStyle: hintStyle ?? TextStyle(fontSize: 14.spMin, fontWeight: FontWeight.w400, color: AppColor.grey600),
      hintTextDirection: hintTextDirection,
      hintMaxLines: hintMaxLines,
      hintFadeDuration: hintFadeDuration,
      error: error,
      errorText: errorText,
      errorStyle: errorStyle ?? TextStyle(fontSize: 12.spMin, fontWeight: FontWeight.w400, color: AppColor.red500),
      errorMaxLines: errorMaxLines,
      floatingLabelBehavior: floatingLabelBehavior,
      floatingLabelAlignment: floatingLabelAlignment,
      isCollapsed: isCollapsed,
      isDense: isDense,
      contentPadding: contentPadding ?? EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
      prefixIcon: prefixIcon != null
          ? Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: prefixIcon,
            )
          : null,
      prefixIconConstraints: prefixIconConstraints ?? BoxConstraints(minHeight: 24.h, minWidth: 24.h),
      prefix: prefix,
      prefixText: prefixText,
      prefixStyle: prefixStyle,
      prefixIconColor: prefixIconColor,
      suffixIcon: suffixIcon,
      suffix: suffix,
      suffixText: suffixText,
      suffixStyle: suffixStyle,
      suffixIconColor: suffixIconColor,
      suffixIconConstraints: suffixIconConstraints ?? BoxConstraints(minHeight: 24.h, minWidth: 24.h),
      counter: counter,
      counterText: counterText == null ? null : '',
      counterStyle: counterStyle,
      filled: filled ?? true,
      fillColor: enabled == false ? AppColor.grey500 : fillColor ?? Colors.white,
      focusColor: focusColor,
      hoverColor: hoverColor,
      errorBorder: errorBorder,
      focusedBorder: focusedBorder ??
          OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.r),
            borderSide: const BorderSide(color: AppColor.grey500),
          ),
      focusedErrorBorder: focusedErrorBorder,
      disabledBorder: disabledBorder,
      enabledBorder: enabledBorder ??
          OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.r),
            borderSide: const BorderSide(color: AppColor.grey500),
          ),
      border: border ??
          OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.r),
            borderSide: const BorderSide(color: AppColor.grey500),
          ),
      decorationEnabled: decorationEnabled ?? true,
      semanticCounterText: semanticCounterText,
      alignLabelWithHint: alignLabelWithHint,
      constraints: constraints,

      ///////////////////////////////// Form Decoration End /////////////////////////////////
      ///////////////////////////////////////////////////////////////////////////////////////

      ///////////////////////////////////////////////////////////////////////////////////////
      ////////////////////////////// Custom Form Element Start //////////////////////////////

      nextFocus: nextFocus,
      customAction: customAction,

      /////////////////////////////// Custom Form Element End ///////////////////////////////
      ///////////////////////////////////////////////////////////////////////////////////////
    );
  }

  @override
  State<CommonForm> createState() => _CommonFormState();
}

class _CommonFormState extends State<CommonForm> {
  /// 텍스트 필드의 컨트롤러
  late final TextEditingController? _controller;
  late final FocusNode _focusNode;

  /// 키보드 위에 버튼을 추가하기 위한 오버레이 엔트리
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    /// 컨트롤러가 없을 경우 자체 컨트롤러 생성하여 사용 (초기값에 값을 넣으면 자동 설정된다.)
    if (widget.controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
    } else {
      /// 컨트롤러가 있을 경우 해당 컨트롤러 사용 (초기값을 무시하며, 초기값이 필요한 경우 상위 위젯에서 컨트롤러에 설정해야 한다.)
      _controller = null;
    }

    if (widget.focusNode == null) {
      /// 포커스 노드가 없을 경우 자체 포커스 노드 생성하여 사용.
      _focusNode = FocusNode();
    } else {
      /// 포커스 노드가 있을 경우 해당 포커스로 초기화하여 사용. 이벤트 리스너 추가
      _focusNode = widget.focusNode!;
    }

    // _focusNode.addListener(() {
    //   if (_focusNode.hasFocus) {
    //     /// 포커스가 되면 키보드 위에 액션 버튼을 추가하는 이벤트 리스너 추가.
    //     addKeyboardActionButton();
    //   } else {
    //     /// 포커스가 해제되면 키보드 위에 액션 버튼을 제거하는 이벤트 리스너 추가.
    //     removeKeyboardActionButton();
    //   }
    // });

    super.initState();
  }

  // void addKeyboardActionButton() {
  //   if (_overlayEntry == null) {
  //     _overlayEntry = OverlayEntry(
  //       opaque: false,
  //       builder: (context) {
  //         return Positioned(
  //           bottom: MediaQuery.of(context).viewInsets.bottom,
  //           child: KeyboardAboveActionButton(nextFocus: widget.nextFocus, customAction: widget.customAction),
  //         );
  //       },
  //     );
  //
  //     Overlay.of(context).insert(_overlayEntry!);
  //   }
  // }
  //
  // void removeKeyboardActionButton() {
  //   _overlayEntry?.remove();
  //   _overlayEntry = null;
  // }

  @override
  void dispose() {
    // removeKeyboardActionButton();
    _overlayEntry?.dispose();

    /// 상위에서 할당된 포커스 노드가 없을 경우 자체 포커스 노드 dispose
    /// 상위에서 할당된 포커스 노드가 있을 경우 상위에서 dispose 해야한다.
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      ////////////////////////////////////////////////////////////////////////////////////////////////////
      //////////////////////////////// FormBuilderTextField Setting Start ////////////////////////////////
      name: widget.name,
      validator: widget.validator,
      onChanged: (value) {
        if (widget.onChanged != null) {
          if (widget.controller == null) {
            widget.onChanged!(_controller!);
          } else {
            widget.onChanged!(widget.controller!);
          }
        }
      },
      valueTransformer: widget.valueTransformer,
      enabled: widget.enabled,
      onSaved: widget.onSaved,
      autovalidateMode: widget.autovalidateMode,
      onReset: widget.onReset,
      focusNode: _focusNode,
      restorationId: widget.restorationId,
      // initialValue 와 controller 는 동시에 사용할 수 없다.
      // 내부에서 controller 를 자동 사용하므로 initialValue 는 controller 의 초기값으로 설정하는데 사용한다.
      // initialValue: widget.initialValue,
      readOnly: widget.readOnly,
      maxLines: widget.maxLines,
      obscureText: widget.obscureText,
      textCapitalization: widget.textCapitalization,
      scrollPadding: widget.scrollPadding,
      enableInteractiveSelection: widget.enableInteractiveSelection,
      maxLengthEnforcement: widget.maxLengthEnforcement,
      textAlign: widget.textAlign,
      autofocus: widget.autofocus,
      autocorrect: widget.autocorrect,
      cursorWidth: widget.cursorWidth,
      cursorHeight: widget.cursorHeight,
      keyboardType: widget.keyboardType,
      style: widget.style,
      controller: widget.controller ?? _controller,
      textInputAction: widget.textInputAction,
      strutStyle: widget.strutStyle,
      textDirection: widget.textDirection,
      maxLength: widget.maxLength,
      onEditingComplete: widget.onEditingComplete,
      onSubmitted: widget.onSubmitted,
      inputFormatters: widget.inputFormatters,
      cursorRadius: widget.cursorRadius,
      cursorColor: widget.cursorColor,
      keyboardAppearance: widget.keyboardAppearance,
      buildCounter: widget.buildCounter,
      expands: widget.expands,
      minLines: widget.minLines,
      showCursor: widget.showCursor,
      onTap: widget.onTap,
      onTapOutside: widget.onTapOutside,
      enableSuggestions: widget.enableSuggestions,
      textAlignVertical: widget.textAlignVertical,
      dragStartBehavior: widget.dragStartBehavior,
      scrollController: widget.scrollController,
      scrollPhysics: widget.scrollPhysics,
      // selectionWidthStyle: widget.selectionWidthStyle,
      smartDashesType: widget.smartDashesType,
      smartQuotesType: widget.smartQuotesType,
      // selectionHeightStyle: widget.selectionHeightStyle,
      autofillHints: widget.autofillHints,
      obscuringCharacter: widget.obscuringCharacter,
      mouseCursor: widget.mouseCursor,
      // contextMenuBuilder: widget.contextMenuBuilder,
      magnifierConfiguration: widget.magnifierConfiguration,
      contentInsertionConfiguration: widget.contentInsertionConfiguration,

      ///////////////////////////////// FormBuilderTextField Setting End /////////////////////////////////
      ////////////////////////////////////////////////////////////////////////////////////////////////////

      ///////////////////////////////////////////////////////////////////////////////////////
      //////////////////////////////// Form Decoration Start ////////////////////////////////

      decoration: InputDecoration(
        icon: widget.icon,
        iconColor: widget.iconColor,
        label: widget.label,
        labelText: widget.labelText,
        labelStyle: widget.labelStyle,
        floatingLabelStyle: widget.floatingLabelStyle,
        helperText: widget.helperText,
        helperStyle: widget.helperStyle,
        helperMaxLines: widget.helperMaxLines,
        hintText: widget.hintText,
        hintStyle: widget.hintStyle,
        hintTextDirection: widget.hintTextDirection,
        hintMaxLines: widget.hintMaxLines,
        hintFadeDuration: widget.hintFadeDuration,
        error: widget.error,
        errorText: widget.errorText,
        errorStyle: widget.errorStyle,
        errorMaxLines: widget.errorMaxLines,
        floatingLabelBehavior: widget.floatingLabelBehavior,
        floatingLabelAlignment: widget.floatingLabelAlignment,
        isCollapsed: widget.isCollapsed,
        isDense: widget.isDense,
        contentPadding: widget.contentPadding,
        prefixIcon: widget.prefixIcon,
        prefixIconConstraints: widget.prefixIconConstraints,
        prefix: widget.prefix,
        prefixText: widget.prefixText,
        prefixStyle: widget.prefixStyle,
        prefixIconColor: widget.prefixIconColor,
        suffixIcon: widget.suffixIcon,
        suffix: widget.suffix,
        suffixText: widget.suffixText,
        suffixStyle: widget.suffixStyle,
        suffixIconColor: widget.suffixIconColor,
        suffixIconConstraints: widget.suffixIconConstraints,
        counter: widget.counter,
        counterText: widget.counterText,
        counterStyle: widget.counterStyle,
        filled: widget.filled,
        fillColor: widget.fillColor,
        focusColor: widget.focusColor,
        hoverColor: widget.hoverColor,
        errorBorder: widget.errorBorder,
        focusedBorder: widget.focusedBorder,
        focusedErrorBorder: widget.focusedErrorBorder,
        disabledBorder: widget.disabledBorder,
        enabledBorder: widget.enabledBorder,
        border: widget.border,
        enabled: widget.decorationEnabled,
        semanticCounterText: widget.semanticCounterText,
        alignLabelWithHint: widget.alignLabelWithHint,
        constraints: widget.constraints,
      ),

      ///////////////////////////////// Form Decoration End /////////////////////////////////
      ///////////////////////////////////////////////////////////////////////////////////////
    );
  }
}
