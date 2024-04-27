import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_prefs_provider.g.dart';

@Riverpod()
class SharedPrefs extends _$SharedPrefs {
  SharedPreferences? prefs;

  @override
  FutureOr<SharedPreferences> build() {
    return init();
  }

  Future<SharedPreferences> init() async {
    prefs = await SharedPreferences.getInstance();
    return prefs!;
  }

  bool isInit() {
    return prefs != null;
  }

  bool containsKey(String key) {
    if (isInit()) {
      return prefs!.containsKey(key);
    } else {
      throw notInitException();
    }
  }

  Future<void> setStringList(String key, List<String> stringList) async {
    if (isInit()) {
      await prefs!.setStringList(key, stringList);
    } else {
      throw notInitException();
    }
  }

  List<String> getStringList(String key) {
    if (isInit()) {
      return prefs!.getStringList(key) ?? [];
    } else {
      throw notInitException();
    }
  }

  Future<void> remove(String key) async {
    if (isInit()) {
      await prefs!.remove(key);
    } else {
      throw notInitException();
    }
  }

  Exception notInitException() {
    return Exception('SharedPreferences 가 초기화되지 않았습니다.');
  }
}