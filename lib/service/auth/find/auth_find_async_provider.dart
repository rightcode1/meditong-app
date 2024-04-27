import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/repository/auth/auth_repository.dart';

final authFindAsyncProvider = AsyncNotifierProvider.autoDispose<AuthFindAsyncNotifier, dynamic>(() => AuthFindAsyncNotifier());

class AuthFindAsyncNotifier extends AutoDisposeAsyncNotifier<dynamic> {
  @override
  FutureOr build() {
    return null;
  }

  /// 휴대번호를 전달받아 아이디를 조회한다.
  Future<String> findLoginIdByTel({ required String tel }) async {
    try {
      final response = await ref.read(authRepositoryProvider).findLoginId(tel: tel);

      return response.data['loginId'];
    } catch (err, stack) {
      debugPrint(err.toString());
      debugPrint(stack.toString());

      throw Exception('데이터를 불러오는 중 오류가 발생했습니다.');
    }
  }
}