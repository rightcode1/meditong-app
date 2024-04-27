import 'package:meditong/service/user/provider/user_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/auth/provider/form/join/auth_join_form_provider.dart';

final providerMgmtProvider = StateNotifierProvider<ProviderMgmtStateNotifier, List<dynamic>>((ref) => ProviderMgmtStateNotifier(ref: ref));

/// 현재 프로바이더에 등록된 모든 프로바이더들을 동시에 제어하기 위한 메인 프로바이더
class ProviderMgmtStateNotifier extends StateNotifier<List<dynamic>> {
  final Ref ref;
  ProviderMgmtStateNotifier({required this.ref}): super([
    authJoinFormProvider,
    userInfoProvider,
  ]);

  /// 현재 등록된 프로바이더에 대한 모든 캐시를 제거한다. 주로 로그아웃 시 사용한다.
  void invalidateAll() {
    for (dynamic eachProvider in state) {
      debugPrint('${eachProvider.name} 이 초기화되었습니다.');
      ref.invalidate(eachProvider);
    }
  }
}