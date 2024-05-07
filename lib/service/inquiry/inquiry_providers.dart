import 'package:flutter/material.dart';
import 'package:mediport/core/exception/request_exception.dart';
import 'package:mediport/domain/model/inquiry/res/inquiry_res.dart';
import 'package:mediport/domain/model/user/res/user_res.dart';
import 'package:mediport/domain/repository/inquiry/inquiry_repository.dart';
import 'package:mediport/service/user/provider/user_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/model/inquiry/req/inquiry_req_register.dart';
import '../../presentation/inquiry/provider/inquiry_form_provider.dart';

part 'inquiry_providers.g.dart';

@Riverpod()
Future<bool> inquiryRegister(InquiryRegisterRef ref) async {
  try {
    final formState = ref.read(inquiryFormProvider);
    final requestDto = InquiryReqRegister.fromJson(formState.toJson());

    await ref.read(inquiryRepositoryProvider).register(body: requestDto);

    return true;
  } catch (err, stack) {
    debugPrint(err.toString());
    debugPrint(stack.toString());

    throw Exception('서버 요청 중 오류가 발생했습니다.');
  }
}

@riverpod
Future<List<InquiryRes>> inquiryList(InquiryListRef ref) async {
  try {
    final user = ref.read(userInfoProvider) as UserRes;
    final response = await ref.read(inquiryRepositoryProvider).list(userId: user.id);

    return response.data!;
  } catch (err, stack) {
    debugPrint(err.toString());
    debugPrint(stack.toString());

    throw RequestException(message: err.toString());
  }
}

@riverpod
Future<InquiryRes> inquiryDetail(InquiryDetailRef ref, { required int inquiryId }) async {
  try {
    final response = await ref.read(inquiryRepositoryProvider).detail(id: inquiryId);
    return response.data!;
  } catch (err, stack) {
    debugPrint(err.toString());
    debugPrint(stack.toString());

    throw RequestException(message: err.toString());
  }
}