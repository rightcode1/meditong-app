import 'package:flutter_riverpod/flutter_riverpod.dart';


/// GoRouterUtils 내에서 로그인 후 이동되는 페이지에 전달될 데이터를 저장할 임시 ExtraProvider
final extraProvider = StateProvider<Object?>((ref) => null);