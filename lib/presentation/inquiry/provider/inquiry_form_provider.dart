import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/inquiry_form_model.dart';

part 'inquiry_form_provider.g.dart';

@Riverpod()
class InquiryForm extends _$InquiryForm {
  @override
  InquiryFormModel build() {
    return InquiryFormModel();
  }

  void changeTitle(String title) {
    state = state.copyWith(
      title: title,
    );

    debugPrint(state.toString());
  }

  void changeContent(String content) {
    state = state.copyWith(
      content: content
    );

    debugPrint(state.toString());
  }
}