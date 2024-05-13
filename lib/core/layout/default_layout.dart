import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediport/core/constant/app_color.dart';
import 'package:mediport/core/constant/data.dart';
import 'package:mediport/domain/model/version/res/version_res.dart';
import 'package:mediport/domain/repository/version/version_repository.dart';
import 'package:mediport/service/version/version_providers.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:store_redirect/store_redirect.dart';

/// 기본 레이아웃을 지정한다.
/// TODO: Version 체크 로직 작성
class DefaultLayout extends ConsumerStatefulWidget {
  final Widget child;

  final Color? backgroundColor;

  /// default: false 앱바 보여줄지에 대한 여부
  final bool showAppBar;

  /// 뒤로가기 버튼을 보여줄지에 대한 여부, showClose 와 함께 쓸 경우 예외를 발생시킨다.
  /// default: false
  final bool showBack;

  /// X 표시를 보여줄지에 대한 여부, showBack 과 함께 쓸 경우 예외를 발생시킨다.
  /// default: false
  final bool showClose;

  /// X 표시를 클릭 시 추가적인 로직 동작
  ///
  /// 정의하지 않을 시, context.pop() 으로 동작한다.
  final VoidCallback? onClosePressed;

  /// 앱바 제목
  final String title;

  /// 앱바 위젯 타이틀
  final Widget? titleWidget;

  /// Bottom navigation bar
  final Widget? bottomNavigationBar;

  /// 패딩을 위한 EdgeInsets
  final EdgeInsetsGeometry? padding;

  final List<Widget> actions;

  // 앱바 하단 경계선을 그릴지에 대한 여부
  final bool showBottomDivider;

  /// back 버튼에서 추가 기능을 원할 때 사용
  final VoidCallback? onBackPressed;

  final Widget? flexibleSpace;

  final PreferredSizeWidget? bottomWidget;

  final double actionsRightPadding;

  /// 앱바 높이
  final double appBarHeight;

  final bool? centerTitle;

  final Widget? floatingActionButton;

  final FloatingActionButtonLocation floatingActionButtonLocation;

  /// 로딩 Dimmer 활성화 여부
  final bool isLoading;

  const DefaultLayout({
    required this.child,
    this.backgroundColor,
    this.showAppBar = false,
    this.showBack = false,
    this.showClose = false,
    this.onClosePressed,
    this.title = '',
    this.titleWidget,
    this.bottomNavigationBar,
    this.padding,
    this.actions = const [],
    this.showBottomDivider = false,
    this.onBackPressed,
    this.bottomWidget,
    this.flexibleSpace,
    this.actionsRightPadding = 16,
    this.appBarHeight = 56.0,
    this.centerTitle,
    this.floatingActionButton,
    this.floatingActionButtonLocation = FloatingActionButtonLocation.endFloat,
    this.isLoading = false,
    super.key,
  });

  @override
  ConsumerState<DefaultLayout> createState() => _DefaultLayoutState();
}

class _DefaultLayoutState extends ConsumerState<DefaultLayout> {
  // TODO: FCM 사용 시 하기 주석 해제하여 사용
  // final _fcmOnMessageOpenedApp = FirebaseMessaging.onMessageOpenedApp;
  // late final StreamSubscription _sub;

  @override
  void initState() {
    super.initState();

    // TODO: FCM 사용 시 하기 주석 해제하여 사용
    // FCM 에 의해 앱이 실행되었을 경우에 대한 리스너를 정의한다.
    // _sub = _fcmOnMessageOpenedApp.listen((event) {
    //   EasyThrottle.throttle('a', const Duration(seconds: 1), () {
    //     debugPrint('===> 호출!!');
    //     /// 리스너가 두 번 호출되고 최초 1회 호출 시에는 Context 가 살아있지 않은 상태이다. 따라서, try-catch 로 변경하고 두 번째 호출 시에 대한 푸시 데이터가 정상적으로 하기 헬퍼 메소드로 넘어갈 수 있도록 처리한다.
    //     try {
    //       CoreUtils.deepLinkMoveToSpecificScreen(rootNavigatorKey.currentContext!, event.data, widgetRef: ref);
    //     } catch (_) {}
    //   });
    // });

    // 서버의 현재 버전을 체크한다.
    // AOS/IOS 환경으로 분기하여 처리한다.
    // 단, 스플래시 화면에서는 체크하지 않는다.
    // 또한, 현재 사용 중인 기기 OS 별 스토어 버전을 체크하여, 서버와 상이할 경우 업데이트한다.
    if (!kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        if (GoRouterState.of(context).path != '/splash') {
          late VersionRes versionModel;
          late int version;

          if (Platform.isAndroid) {
            versionModel = await ref.read(versionRepositoryProvider).version().then((value) => value.data!);
            version = versionModel.aosVer;
          } else if (Platform.isIOS) {
            versionModel = await ref.read(versionRepositoryProvider).version().then((value) => value.data!);
            version = versionModel.iosVer;
          }

          final int currentAppVersion = await PackageInfo.fromPlatform().then((info) => int.parse(info.buildNumber));

          debugPrint('===> Version from server: $version');
          debugPrint('===> Current app version: $currentAppVersion');

          // 만일, 서버의 버전이 현재 앱의 빌드 버전보다 높을 경우, 스토어 또는 마켓으로 강제 이동시킨다.
          // ex.)
          //      currentAppVersion: 14
          //      versionFromServer: 15
          //      ===> Then move to app store or google market.
          if (currentAppVersion < version) {
            debugPrint('===> 서버 내 앱 버전이 현재 앱 버전보다 높습니다. 강제 업데이트가 필요합니다.');

            if (context.mounted) {
              await renderDialog(context);
            }
          }

          /* 서버와 현재 OS 에 해당하는 스토어의 버전을 체크하여 상이할 경우, 서버 내 버전을 스토어 버전 기준으로 갱신한다. */
          final storeVersionStatus = await NewVersionPlus().getVersionStatus();
          final storeVersion = storeVersionStatus?.storeVersion;

          if (storeVersion != null) {
            if (Platform.isAndroid) {
              final aosStoreVerFromServer = versionModel.aosStoreVer;

              if (storeVersion != aosStoreVerFromServer) {
                ref.read(versionUpdateProvider(aosStoreVer: storeVersion));
              }
            } else if (Platform.isIOS) {
              final iosStoreVerFromServer = versionModel.iosStoreVer;

              if (storeVersion != iosStoreVerFromServer) {
                ref.read(versionUpdateProvider(iosStoreVer: storeVersion));
              }
            }
          }
        }
      });
    }
  }

  Future<void> renderDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            '업데이트 필요',
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              //List Body를 기준으로 Text 설정
              children: const <Widget>[
                Text('신규 업데이트가 있습니다.'),
                Text('앱을 사용하시려면 업데이트 해주세요!'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('업데이트하러 가기'),
              onPressed: () async {
                await StoreRedirect.redirect(androidAppId: ANDROID_APP_ID, iOSAppId: IOS_APP_ID);
              },
            ),
          ],
        );
      },
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // show AppBar 가 false 이나, showBack, showClose 가 true 일 경우 예외를 발생시킨다.
    if (!widget.showAppBar &&
        (widget.showBack || widget.showClose || widget.title.isNotEmpty || widget.actions.isNotEmpty || widget.titleWidget != null)) {
      throw Exception(
          'showAppBar 가 활성화되지 않은 상태에서 showBack, title 또는 showClose, actions 프로퍼티를 사용할 수 없습니다.\n\nshowAppBar 프로퍼티를 true 로 변경한 후, 해당 프로퍼티들을 사용해주세요.');
    }

    // showBack, showClose 가 동시에 True 일 경우, 예외를 발생시킨다.
    if (widget.showBack && widget.showClose) {
      throw Exception('showBack 과 showClose 속성은 함께 사용될 수 없습니다.');
    }

    // title, imageTitle 가 동시에 사용 될 경우, 예외를 발생시킨다.
    if (widget.title.isNotEmpty && widget.titleWidget != null) {
      throw Exception('title 과 widgetTitle 속성은 함께 사용될 수 없습니다.');
    }

    // showBottomDivider, bottomWidget 가 동시에 사용 될 경우, 예외를 발생시킨다.
    if (widget.showBottomDivider && widget.bottomWidget != null) {
      throw Exception('showBottomDivider 과 bottomWidget 속성은 함께 사용될 수 없습니다.');
    }

    return GestureDetector(
      // 키보드 활성화 시, 다른 스크린을 클릭할 때 자동으로 키보드가 내려가도록 전역 설정
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Stack(
        children: [
          Scaffold(
            appBar: widget.showAppBar
                ? PreferredSize(
                    preferredSize: Size.fromHeight(widget.appBarHeight.h),
                    child: _renderAppBar(context),
                  )
                : null,
            backgroundColor: widget.backgroundColor ?? Colors.white,
            body: SafeArea(
              bottom: true,
              child: Padding(
                padding: widget.padding == null
                    ? EdgeInsets.symmetric(
                        vertical: 17.8.h,
                        horizontal: 16.0.w,
                      )
                    : widget.padding!,
                child: widget.child,
              ),
            ),
            bottomNavigationBar: widget.bottomNavigationBar,
            floatingActionButton: widget.floatingActionButton,
            floatingActionButtonLocation: widget.floatingActionButtonLocation,
            // extendBody: true,
            resizeToAvoidBottomInset: false,
          ),
          if (widget.isLoading)
            Container(
              width: double.infinity,
              height: MediaQuery.sizeOf(context).height,
              color: Colors.black.withOpacity(0.2),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  /// 렌더를 위한 앱바를 반환한다.
  AppBar _renderAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: widget.showBack ? true : false,
      // App Bar 의 뒤로가기 버튼 출력 여부
      backgroundColor: Colors.white,
      centerTitle: widget.centerTitle ?? false,
      // 앱바 타이틀 가운데 적용 여부
      elevation: 0.0,
      // 앱바 Shadow 해제
      toolbarHeight: widget.appBarHeight.h,
      flexibleSpace: widget.flexibleSpace,
      // 앱바 우측 X 버튼 활성화 여부, false 일 경우, 지정한 actions 가 출력된다. showClose 가 true 인 상태에서 다른 actions 를 정의할 수 없다.
      actions: widget.showClose
          ? [
              IconButton(
                onPressed: () {
                  if (widget.onClosePressed != null) {
                    widget.onClosePressed!();
                  } else {
                    context.pop();
                  }
                },
                icon: Image.asset(
                  'assets/icons/common/close_black.png',
                  height: 22.0.h,
                ),
              ),
              SizedBox(
                width: 16.0.w,
              ) // 액션 버튼의 오른쪽에 16 pixel 만큼의 여백을 둔다.
            ]
          : [
              ...widget.actions,
              SizedBox(
                width: widget.actionsRightPadding.w,
              ) // 액션
            ],
      leading: widget.showBack
          ? IconButton(
            icon: Image.asset('assets/icons/common/arrow_back_black@3x.png', height: 24.0.h),
            onPressed: widget.onBackPressed ??
                () {
                  // 스택에 남아있는 페이지가 없을 경우, 에외를 발생시킨다.
                  if (!context.canPop()) {
                    throw Exception('뒤로갈 수 있는 페이지가 존재하지 않습니다. 코드를 다시 확인해주세요.');
                  }
                  context.pop();
                },
          )
          : null,
      // title 이 위젯일 경우, 위젯을 그대로 렌더링하고, 아닐 경우 text 로 구성된 title 을 렌더링한다. widgetTitle, title 은 동시에 사용될 수 없다.
      title: widget.titleWidget ??
          Text(
            widget.title,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 20.0.sp,
            ),
          ),
      titleSpacing: widget.showBack ? -8.0 : 16.0,
      // 앱바 하단 Divider 적용
      bottom: widget.bottomWidget != null
          ? widget.bottomWidget!
          : widget.showBottomDivider
              ? PreferredSize(
                  preferredSize: Size.fromHeight(8.0.h),
                  child: Divider(
                    color: AppColor.grey400,
                    thickness: 1.0,
                    height: 0.0.h,
                  ),
                )
              : null,
    );
  }
}
