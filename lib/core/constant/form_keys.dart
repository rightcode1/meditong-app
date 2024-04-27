import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

/// 앱 내에서 [FormBuilder] 를 통해 Form 을 구성할 때 사용하기 위한 [GlobalKey] 를 정의하는 파일
/// 키를 정의함으로써 앱 내의 다양한 파일에서 특정 폼 데이터를 그대로 불러와 사용할 수 있다.
/// 단, Duplicated Key Exception 에 유의할 것.

GlobalKey<FormBuilderState> loginFormKey = GlobalKey<FormBuilderState>();
GlobalKey<FormBuilderState> joinFormKey = GlobalKey<FormBuilderState>();