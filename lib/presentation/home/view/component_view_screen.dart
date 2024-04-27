import 'package:meditong/core/component/carousel/image_carousel.dart';
import 'package:meditong/core/component/chip/common_chip.dart';
import 'package:meditong/core/component/image/common_add_image.dart';
import 'package:meditong/core/constant/app_color.dart';
import 'package:meditong/core/enum/app_router.dart';
import 'package:meditong/core/util/core_utils.dart';
import 'package:meditong/core/util/go_router_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meditong/core/component/buttons/add_image_button.dart';
import 'package:meditong/core/component/buttons/common_button.dart';
import 'package:meditong/core/component/buttons/common_outlined_button.dart';
import 'package:meditong/core/component/buttons/more_toggle_button.dart';
import 'package:meditong/core/component/checkbox/checkbox_list_with_all_check.dart';
import 'package:meditong/core/component/divider/thick_divider.dart';
import 'package:meditong/core/component/.etc/no_list_widget.dart';
import 'package:meditong/core/component/image/image_container.dart';
import 'package:meditong/core/component/label/common_label.dart';
import 'package:meditong/core/component/tabbar/common_tab_bar.dart';
import 'package:meditong/core/layout/default_layout.dart';
import 'package:meditong/core/util/bottom_sheet_utils.dart';
import 'package:meditong/core/util/dialog_utils.dart';
import 'package:meditong/core/util/toast_utils.dart';
import 'package:go_router/go_router.dart';

class ComponentViewScreen extends ConsumerStatefulWidget {
  const ComponentViewScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ComponentViewScreen> createState() => _ComponentViewScreenState();
}

class _ComponentViewScreenState extends ConsumerState<ComponentViewScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: FCM 사용 시, 하기 코드를 앱의 스플래시 스크린 이후의 엔트리 포인트 (ex. HomeScreen) 내에 그대로 붙여넣기
    /* 앱이 Terminated 되었을 때의 환경에서 푸시 클릭 후, 앱 내 엔트리 포인트 진입 시 푸시 내의 데이터를 바탕으로 적절한 화면으로 이동하기 위한 리스너를 정의한다. */
    // FirebaseMessaging.instance.getInitialMessage().then((value) {
    //   EasyThrottle.throttle('getInitialFcmData', const Duration(seconds: 3), () {
    //     debugPrint('===> 초기 FCM 데이터=${value?.data}');
    //     if (value != null) {
    //       final data = value.data;
    //
    //       CoreUtils.deepLinkMoveToSpecificScreen(context, data, widgetRef: ref);
    //     }
    //   });
    // });

    /* PoPScope 내의 onPopInvoked 를 활용하여 뒤로가기 버튼이 두 번 연속 눌렸을 경우 앱을 종료시킨다. */
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) => CoreUtils.appExitWithBackButton(context),
      child: DefaultLayout(
        showAppBar: true,
        showBack: true,
        title: '컴포넌트 리스트',
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                /* 해당 버튼을 클릭하면, 로그인 후 홈 화면으로 이동시킨다. */
                ElevatedButton(
                    onPressed: () => GoRouterUtils.recordExpectedRouteAndGoToAuth(context, ref, expectedRoute: AppRouter.home.name),
                    child: const Text('로그인 후 홈 화면 이동')),
                CommonButton(text: 'CommonButton', onPressed: () {}),
                CommonOutlinedButton(
                  isLoading: true,
                  text: 'CommonOutlineButton',
                  onPressed: () {},
                ),
                CommonAddImage(
                  crossAxisCount: 4,
                  scrollDirection: Axis.vertical,
                  maxImageCount: 6,
                  onImageAdded: (selectedImages) {},
                  onImageDeleted: (deleteImage, deleteNetworkImage) {},
                ),
                MoreToggleButton(buttonText: 'MoreToggleButton', boolCallback: (val) {}, isMore: false),
                CheckboxListWithAllCheck(
                  checkboxNameList: ['체크1', '체크2'],
                  checkboxContentList: ['유의사항 1', '유의사항 2'],
                  allCheckboxSelectedCallback: (isAllSelected) {},
                ),
                ImageContainer(
                  fromNetwork: true,
                  imagePath: 'https://test-template-images.s3.ap-northeast-2.amazonaws.com/program/8afc9bd2-94e1-4d34-af0a-5ce742ef5c08.jpg',
                  closeButtonPressed: () {},
                ),
                SizedBox(
                  height: 40.0.h,
                ),
                const Text('Thick Divider'),
                const ThickDivider(),
                SizedBox(
                  height: 40.0.h,
                ),
                const CommonLabel(label: 'CommonLabel', child: Text('위젯이 들어갈 수 있습니다.')),
                SizedBox(
                  height: 40.0.h,
                ),
                ImageCarousel(
                  itemHeight: 300.0.h,
                  itemList: [
                    CachedNetworkImage(
                      imageUrl: 'https://static.remove.bg/sample-gallery/graphics/bird-thumbnail.jpg',
                      fit: BoxFit.cover,
                    )
                  ],
                ),
                SizedBox(
                  height: 40.0.h,
                ),
                CommonTabBar(
                  tabController: _tabController,
                  tabList: const [
                    Tab(text: 'tab1'),
                    Tab(text: 'tab2'),
                  ],
                ),
                SizedBox(
                  height: 40.0.h,
                ),
                const Wrap(
                  children: [
                    CommonChip(text: '텍스트'),
                    CommonChip(
                      backgroundColor: AppColor.red500,
                      textWidget: Column(
                        children: [
                          Text(
                            '텍스트 위젯 Col',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text('텍스트 위젯 Col'),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 40.0.h,
                ),
                NoListWidget(
                  isButton: true,
                  buttonText: '확인',
                  onButtonPressed: () {},
                  text: '데이터 없음',
                ),
                CommonButton(
                  text: 'NoButtonBottomSheet',
                  onPressed: () {
                    BottomSheetUtils.showNoButton(
                      context: context,
                      title: '제목',
                      contentWidget: (bottomState) {
                        return const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 40.0),
                            Text('내용입니다.'),
                            SizedBox(height: 40.0),
                          ],
                        );
                      },
                    );
                  },
                ),
                CommonButton(
                  text: 'OneButtonBottomSheet',
                  onPressed: () {
                    BottomSheetUtils.showOneButton(
                      context: context,
                      title: '제목',
                      contentWidget: (bottomState) {
                        return const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 40.0),
                            Text('내용입니다.'),
                            SizedBox(height: 40.0),
                          ],
                        );
                      },
                      buttonText: '확인',
                    );
                  },
                ),
                CommonButton(
                  text: 'TwoButtonBottomSheet',
                  onPressed: () {
                    BottomSheetUtils.showTwoButton(
                      context: context,
                      title: '제목 heightFactor 0.5',
                      contentWidget: (bottomState) {
                        return const Column(
                          children: [Text('텍스트')],
                        );
                      },
                      leftButtonText: '왼쪽 버튼',
                      onLeftButtonPressed: () {
                        Navigator.of(context).pop();
                      },
                      rightButtonText: '오른쪽 버튼',
                      onRightButtonPressed: () {
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
                CommonButton(
                  text: 'CalendarBottomSheet',
                  onPressed: () {
                    BottomSheetUtils.showDateSelectableCalendar(
                      context: context,
                      title: '날짜 바텀 시트',
                      leftButtonText: '오른쪽 버튼',
                      rightButtonText: '왼쪽 버튼',
                      onLeftButtonPressed: () {},
                      onRightButtonPressed: (selectedDate) {},
                    );
                  },
                ),
                CommonButton(
                  text: 'OneButtonDialog',
                  onPressed: () {
                    DialogUtils.showOneButton(
                      context: context,
                      title: '제목',
                      content: '',
                      contentWidget: (bottomState) {
                        return CheckboxListTile(
                          value: true,
                          title: Text('체크박스'),
                          onChanged: (value) {},
                        );
                      },
                      buttonText: '확인',
                      onButtonPressed: () {
                        context.pop();
                      },
                    );
                  },
                ),
                CommonButton(
                  text: 'TwoButtonDialog',
                  onPressed: () {
                    DialogUtils.showTwoButton(
                      context: context,
                      title: '제목',
                      content: '내용',
                      leftButtonText: '취소',
                      rightButtonText: '확인',
                      onLeftButtonPressed: () {
                        context.pop();
                      },
                      onRightButtonPressed: () {
                        context.pop();
                      },
                    );
                  },
                ),
                CommonButton(
                  text: 'showToast',
                  onPressed: () {
                    ToastUtils.showToast(context, toastText: '토스트창입니다.', duration: const Duration(seconds: 3));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
