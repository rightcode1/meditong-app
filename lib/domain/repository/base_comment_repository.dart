import 'package:mediport/domain/model/base_comment_req_register.dart';
import 'package:mediport/domain/model/base_comment_req_update.dart';
import 'package:mediport/domain/model/base_comment_res.dart';
import 'package:mediport/domain/model/base_res.dart';

abstract class BaseCommentRepository {
  Future<BaseResponse> register({
    required BaseCommentReqRegister body,
  });

  Future<BaseResponse<List<BaseCommentRes>>> list({
    required int page,
    int? limit,
    required int contentId,
  });

  Future<BaseResponse> update({
    required int commentId,
    required BaseCommentReqUpdate body,
  });

  Future<BaseResponse> remove({
    required int commentId,
  });
}
