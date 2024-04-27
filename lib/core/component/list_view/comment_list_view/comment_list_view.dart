import 'dart:io';

import 'package:mediport/core/component/.etc/no_list_widget.dart';
import 'package:mediport/core/component/list_view/comment_list_view/element/comment_list_view_element.dart';
import 'package:mediport/core/component/text_fields/comment_text_field.dart';
import 'package:mediport/core/constant/app_color.dart';
import 'package:mediport/domain/model/base_comment_req_register.dart';
import 'package:mediport/domain/model/base_comment_req_update.dart';
import 'package:mediport/domain/model/base_comment_res.dart';
import 'package:mediport/domain/model/user/res/user_res.dart';
import 'package:mediport/domain/repository/base_comment_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../service/user/provider/user_providers.dart';

class CommentListView extends ConsumerStatefulWidget {
  /// 부모가 NestedScrollView 인 경우, 부모의 스크롤 컨트롤러를 공유하기 위한 PrimaryScrollController
  final ScrollController? parentScrollController;

  /// 댓글이 위치한 게시글 고유키
  final int contentId;

  /// 댓글 Repository
  final Provider<BaseCommentRepository> commentRepository;

  /// 댓글 작성 API 호출을 위한 body 내 프로퍼티 명 (ex. advertisementId)
  final String idPropertyName;

  final bool isComment;

  /// 댓글 작성창 렌더링 여부
  ///
  /// 해당 컴포넌트를 사용하는 부모 위젯의 오프셋을 감지하여 댓글 창이 메인으로 활성화 될 경우, 텍스트 필드를 활성화시킨다.
  final bool showCommentEditing;

  /// 댓글 리스트 및 댓글 작성을 담당하는 API 성격이 강한 컴포넌트
  ///
  /// NestedScrollView 와 결합하여 사용하는 것을 강력히 추천한다.
  /// 이때, 부모 ScrollController 인 PrimaryScrollController 를 전달하는 것을 추천한다.
  /// 사유는 해당 컴포넌트는 CustomScrollView 및 Sliver 로 구성되어있기 때문이다.
  /// 해당 방법으로 구현한 사유는 PagedListView 의 경우, 내부에 각 댓글 위젯의 렌더링을 위해 ShrinkWrap 및 physics 를 NeverScrollableScrollPhysics 로 설정한다면
  /// InfiniteScrollPagination API 호출 시 모든 페이지에 대하여 서버 측 API 를 호출하기 때문이다.
  /// 따라서, 부모 위젯을 NestedScrollView 로 감싸 부모 위젯의 나머지 크기를 해당 댓글 컴포넌트만큼 차지할 수 있도록 설정하는 것이 현재로써는 최선의 방법으로 사료된다.
  ///
  /// 댓글에 대한 Repository 생성 시, BaseCommentRepository 를 상속받아, 해당 부모 객체의 내부를 구현해야한다. (웰카 advertisement_comment_repository.dart 파일 참고)
  /// 댓글 리스트에 대한 Response 객체는 BaseCommentRes 를 상속하고, Response 객체만 갖는 고유 프로퍼티 (광고의 경우 advertisementId) 만 추가로 명세하여 데이터 클래스를 작성한다. (웰카 advertisement_res_list.dart 파일 참고)
  //
  // 특이한 점은, 댓글을 작성할 때인데, BaseCommentRepository 를 상속받는 Repository 의 "register" 내 Body 의 자료형은 BaseCommentReq 이어야한다. (웰카 advertisement_repository_providert.dart 파일 내 register 메소드 참고)
  // 이는 후술하겠지만, 스웨거 내에서 댓글 작성을 위해 댓글이 달리는 게시글 아이디의 프로퍼티는 advertisementId 등 게시글 고유키의 프로퍼티가 모두 제각각이기 때문이다. 이 부분을 해소하기 위해 BaseCommentReq 를 body 의 자료형으로 삼아야한다.
  //
  // 가장 먼저, 코멘트 리스트 뷰를 사용하기 위해서는 CommentListView 컴포넌트를 사용하면 된다. 총 4개의 프로퍼티가 존재한다.
  // * contentId: advertisementModel.id, /// 게시글의 고유키를 넘겨주면 된다. 여기서는 광고 게시글의 고유키이다.
  // * commentRepository: advertisementCommentRepositoryProvider, /// BaseCommentRepository 를 상속받는 Comment Repository 를 넘겨주면 된다.
  // * idPropertyName: 'advertisementId', /// 댓글 작성 시 필요한 게시글 고유키의 프로퍼티명이다. 명시한 프로퍼티명으로 추후 댓글 작성 시, 자동으로 직렬화하여 해당 프로퍼티 명으로 서버로 전송된다.
  // * isComment: false, /// 댓글 작성 가능 여부. false 일 경우 "댓글을 달 수 없는 게시글입니다." 를 렌더링한다.
  //
  // 여기서 idPropertyName 는, 댓글 작성 API 호출 시, 게시글 고유키의 프로퍼티명에 대한 동적 프로퍼티를 담당하는 역할을 한다.
  // 예를 들어, 광고 게시글에 대한 댓글 작성 Body 는 스웨거에서 명시된 대로라면 다음과 같다,
  // {
  //   "advertisementId": 0, // !!**이 부분**!!
  //   "content": "string"
  // }
  //
  // 타 프로젝트 댓글 작성 body 도 확인한 결과, 상기 형태는 공통적으로 쓰이고 있고, 다만 다른 점은 "advertisementId" 와 같이 게시글 고유키의 네이밍이 모두 상이하므로,
  // 여기에 착안해서 CommentListView 에서는 상기 게시글 프로퍼티명을 명세하기 위한 idPropertyName 을 따로 전달받는다.
  //
  // 해당 값을 넘기면 BaseCommentReq 내의 id 프로퍼티가 전달받은 프로퍼티로 변경되어 서버로 전송된다.
  const CommentListView({
    this.parentScrollController,
    required this.contentId,
    required this.commentRepository,
    required this.idPropertyName,
    required this.isComment,
    this.showCommentEditing = true,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<CommentListView> createState() => _CommentListViewState();
}

class _CommentListViewState extends ConsumerState<CommentListView> with SingleTickerProviderStateMixin {
  ScrollController? get _parentScrollController => widget.parentScrollController;

  int get _contentId => widget.contentId;

  Provider<BaseCommentRepository> get _commentRepository => widget.commentRepository;

  String get _idPropertyName => widget.idPropertyName;

  bool get _isComment => widget.isComment;

  bool get _showCommentEditing => widget.showCommentEditing;

  final _pagingController = PagingController(firstPageKey: 1);

  late AnimationController _animationController;
  late Animation<Offset> _animationOffset;

  /// 댓글 전체 개수
  int _totalCommentCount = 0;

  /// 댓글 TextField Controller
  final _commentTextFieldController = TextEditingController();

  /// 수정 모드 여부 default is false
  bool _isModifyingMode = false;

  /// 현재 수정 중인 댓글 고유키
  int? _currentlyModifyingCommentId;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _animationOffset = Tween<Offset>(begin: Offset.zero, end: const Offset(0.0, 1.0)).animate(_animationController);

    _pagingController.addPageRequestListener((pageKey) {
      fetchData(pageKey);
    });
  }

  Future<void> fetchData(int pageKey) async {
    try {
      final newData = await ref.read(_commentRepository).list(page: pageKey, contentId: _contentId);

      final bool isLastData = newData.meta!.totalPage == pageKey;

      // 전체 댓글 개수
      _totalCommentCount = newData.meta!.totalCount;

      final newItems = newData.data!;

      if (isLastData) {
        _pagingController.appendLastPage(newItems);
      } else {
        _pagingController.appendPage(newItems, pageKey + 1);
      }

      setState(() {});
    } catch (err, stack) {
      debugPrint(err.toString());
      debugPrint(stack.toString());
      _pagingController.error = err;
    }
  }

  /// 댓글 삭제 버튼 클릭 시 핸들러
  Future<void> onCommentDeleteBtnClick({required int commentId}) async {
    try {
      final response = await ref.read(_commentRepository).remove(commentId: commentId);

      if (response.statusCode == HttpStatus.ok) {
        debugPrint('댓글이 정상적으로 삭제되었습니다. commentId=$commentId');

        _pagingController.refresh();
      } else {
        throw Exception('정의되지 않은 상태코드입니다. statusCode=${response.statusCode}');
      }
    } catch (err, stack) {
      throw Exception('댓글 삭제 중 오류가 발생했습니다. err=$err\nstack=$stack');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pagingController.dispose();
    _commentTextFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userInfoProvider) as UserRes?;

    if (_showCommentEditing || _isModifyingMode) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }

    // isComment 에 따라 댓글창 출력 여부를 결정한다.
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          // fit: StackFit.expand,
          children: [
            CustomScrollView(
              controller: _parentScrollController,
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  toolbarHeight: 75.0.h,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Column(
                      children: [
                        SizedBox(height: 16.0.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '댓글',
                              style: TextStyle(
                                fontSize: 18.0.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColor.darkGrey500,
                              ),
                            ),
                            SizedBox(
                              width: 8.0.w,
                            ),
                            Text(
                              '+ $_totalCommentCount',
                              style: TextStyle(
                                fontSize: 18.0.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColor.green500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 13.8.h),
                        Divider(color: AppColor.grey400, height: 0.0, thickness: 1.0.w),
                        SizedBox(height: 19.8.h),
                      ],
                    ),
                  ),
                ),
                PagedSliverList.separated(
                  // shrinkWrap: true,
                  // physics: const NeverScrollableScrollPhysics(),
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate(
                    itemBuilder: (context, item, index) {
                      final eachComment = item as BaseCommentRes;

                      return CommentListViewElement.fromModel(
                        model: eachComment,
                        isMine: user == null ? null : user.id == eachComment.userId,
                        onDeleteBtnClicked: () => onCommentDeleteBtnClick(commentId: eachComment.id),
                        onUpdateBtnClicked: (writtenText) {
                          _commentTextFieldController.text = writtenText;
                          _isModifyingMode = true;
                          _currentlyModifyingCommentId = eachComment.id;

                          setState(() {});
                        },
                      );
                    },
                    animateTransitions: true,
                    noItemsFoundIndicatorBuilder: (context) {
                      return _isComment
                          ? Column(
                            children: [
                              SizedBox(height: 200.0.h),
                              Image.asset('assets/images/common/no_comment_grey@3x.png', height: 48.0.h),
                            ],
                          )
                          : const NoListWidget(text: '댓글을 달 수 없습니다');
                    },
                  ),
                  separatorBuilder: (context, index) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 19.8.h),
                    child: Divider(color: AppColor.grey400, height: 0.0, thickness: 1.0.w),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 100.0.h)),
              ],
            ),
            if (user != null && _isComment)
              Positioned(
                bottom: 0.0,
                child: SlideTransition(
                  position: _animationOffset,
                  child: Container(
                    color: Colors.white,
                    width: constraints.maxWidth,
                    child: CommentTextField(
                      pagingController: _pagingController,
                      textEditingController: _commentTextFieldController,
                      contentId: _contentId,
                      commentRepository: _commentRepository,
                      idPropertyName: _idPropertyName,
                      isModifyingMode: _isModifyingMode,
                      onModifyCloseClicked: () {
                        setState(() {
                          _isModifyingMode = false;
                          _commentTextFieldController.text = '';
                          _currentlyModifyingCommentId = null;
                        });
                      },
                      onCommentRegisterBtnClicked: () async {
                        try {
                          final comment = _commentTextFieldController.text;

                          final requestDto = BaseCommentReqRegister(id: _contentId, content: comment, idPropertyName: _idPropertyName);
                          await ref.read(_commentRepository).register(body: requestDto);
                          _pagingController.refresh();

                          _commentTextFieldController.text = '';
                          FocusManager.instance.primaryFocus?.unfocus();
                        } catch (err, stack) {
                          throw Exception('댓글 등록 중 오류가 발생했습니다. err=$err\nstack=$stack');
                        }
                      },
                      onCommentUpdateBtnClicked: () async {
                        try {
                          final comment = _commentTextFieldController.text;

                          final requestDto = BaseCommentReqUpdate(content: comment);
                          await ref.read(_commentRepository).update(commentId: _currentlyModifyingCommentId!, body: requestDto);
                          _pagingController.refresh();

                          _commentTextFieldController.text = '';
                          _isModifyingMode = false;
                          _currentlyModifyingCommentId = null;
                          FocusManager.instance.primaryFocus?.unfocus();
                        } catch (err, stack) {
                          throw Exception('댓글 등록 중 오류가 발생했습니다. err=$err\nstack=$stack');
                        }
                      },
                    ),
                  ),
                ),
              )
          ],
        );
      },
    );
  }
}
