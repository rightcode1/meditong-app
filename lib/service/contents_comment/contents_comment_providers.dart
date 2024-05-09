import 'package:flutter/material.dart';
import 'package:mediport/core/exception/request_exception.dart';
import 'package:mediport/domain/model/contents_comment/req/contents_comment_req_register.dart';
import 'package:mediport/domain/model/contents_comment/res/contents_comment_res_list.dart';
import 'package:mediport/domain/repository/contents_comment/contents_comment_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contents_comment_providers.g.dart';

@riverpod
class ContentsComment extends _$ContentsComment {
  @override
  Future<List<ContentsCommentResList>> build({required int contentsId}) async {
    return fetchData(contentsId: contentsId);
  }

  Future<List<ContentsCommentResList>> fetchData({required int contentsId}) async {
    try {
      final response = await ref.read(contentsCommentRepositoryProvider).list(contentsId: contentsId);

      return response.data!;
    } catch (err, stack) {
      debugPrint(err.toString());
      debugPrint(stack.toString());

      throw RequestException(message: err.toString());
    }
  }

  /// 댓글을 전송한다.
  Future<bool> register({
    required String content,
    int? contentsCommentId,
  }) async {
    try {
      final requestDto = ContentsCommentReqRegister(
        contentsId: contentsId,
        content: content,
        contentsCommentId: contentsCommentId,
      );

      await ref.read(contentsCommentRepositoryProvider).register(body: requestDto).then((value) => ref.invalidateSelf());

      return true;
    } catch (err, stack) {
      debugPrint(err.toString());
      debugPrint(stack.toString());

      return false;
    }
  }

  /// 댓글을 삭제한다.
  Future<bool> remove({
    required int commentId,
}) async {
    try {
      await ref.read(contentsCommentRepositoryProvider).remove(id: commentId).then((value) => ref.invalidateSelf());
      return true;
    } catch (err, stack) {
      debugPrint(err.toString());
      debugPrint(stack.toString());

      return false;
    }
  }
}
