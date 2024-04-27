import 'package:flutter/rendering.dart';
import 'package:mediport/core/exception/request_exception.dart';
import 'package:mediport/domain/model/alert/req/alert_req_register.dart';
import 'package:mediport/domain/model/alert/res/alert_res_list.dart';
import 'package:mediport/domain/model/user/res/user_res.dart';
import 'package:mediport/domain/repository/alert/alert_repository.dart';
import 'package:mediport/service/user/provider/user_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'alert_providers.g.dart';

@riverpod
class Alert extends _$Alert {
  @override
  Future<List<AlertResList>> build() async {
    return fetchData();
  }

  Future<List<AlertResList>> fetchData() async {
    try {
      final response = await ref.read(alertRepositoryProvider).list();
      return response.data!;
    } catch (err, stack) {
      debugPrint(err.toString());
      debugPrint(stack.toString());

      throw RequestException(message: err.toString());
    }
  }

  /* 알림을 등록한다. :: Opt. Response */
  Future<bool> register({required String keyword}) async {
    try {
      final user = ref.read(userInfoProvider) as UserRes;
      final userId = user.id;

      final requestDto = AlertReqRegister(content: keyword, userId: userId);

      // 캐시를 우선 저장한다.
      state = AsyncValue.data([
        AlertResList(
          id: -1,
          userId: userId,
          content: keyword,
          createdAt: DateTime.now(),
        ),
        ...state.value!,
      ]);

      // 서버에 요청 후, 전달받은 데이터를 바탕으로 캐시를 업데이트한다.
      ref.read(alertRepositoryProvider).register(body: requestDto).then((value) {
        final data = value.data!;

        final id = data.id;
        final createdAt = data.createdAt;
        state = AsyncValue.data(state.value!.map((e) => e.id == -1 ? e.copyWith(id: id, createdAt: createdAt) : e).toList());
      });

      return true;
    } catch (err, stack) {
      debugPrint(err.toString());
      debugPrint(stack.toString());

      return false;
    }
  }

  /* 특정 알림을 삭제한다. :: Opt. Response */
  Future<bool> remove({required int alertId}) async {
    try {
      ref.read(alertRepositoryProvider).remove(id: alertId);
      state = AsyncValue.data(state.value!.where((element) => element.id != alertId).toList());
      return true;
    } catch (err, stack) {
      debugPrint(err.toString());
      debugPrint(stack.toString());

      return false;
    }
  }
}
