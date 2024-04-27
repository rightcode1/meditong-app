/// TODO: 다이나믹 링크 사용 시 주석 해제하여 사용

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
//
// part 'deep_link_provider.g.dart';
//
// @Riverpod(keepAlive: true)
// class DeepLink extends _$DeepLink {
//   @override
//   Uri? build() {
//     return null;
//   }
//
//   /// Deep Link 를 저장한다.
//   void saveDynamicLink({required Uri link}) {
//     state = link;
//   }
//
//   /// Deep Link 를 초기화한다.
//   void initDynamicLink() {
//     state = null;
//   }
//
//   /// Deep Link 를 Path 로 정제 후 해당 페이지로 이동한다.
//   void executeDeepLink(BuildContext context, {Function()? func}) async {
//     /// Deep Link 유효성 검사를 실행하기 전 사용자 정의 함수를 실행한다.
//     /// ex:) context.goNamed() 다른 router 를 먼저 방문할 필요가 있을경우.
//     if (func != null) {
//       await func();
//     }
//
//     if (state == null) return;
//
//     String routerName = '';
//     for (AppRouter router in AppRouter.values) {
//       if (router.name == state!.pathSegments.first) {
//         debugPrint('Router Name : ${router.name}');
//         routerName = router.name;
//
//         break;
//       }
//     }
//
//     if (!context.mounted) return;
//
//     if (routerName.isNotEmpty) {
//       final user = ref.read(userInfoProvider);
//
//       /// 포트폴리오 상세 페이지로 이동
//       if (routerName == AppRouter.portfolioDetail.name) {
//         final Map<String, dynamic> queryParameters = state!.queryParameters;
//         initDynamicLink();
//         context.pushNamed(routerName, queryParameters: queryParameters);
//         return;
//       }
//
//       /// 전문업체 상세 페이지로 이동
//       if (routerName == AppRouter.professionalDetail.name) {
//         final Map<String, dynamic> queryParameters = state!.queryParameters;
//         initDynamicLink();
//         context.pushNamed(routerName, queryParameters: queryParameters);
//         return;
//       }
//
//       /// 유저일 경우
//       if (user is UserRes) {
//         /// 구해요 상세 페이지로 이동
//         if (routerName == AppRouter.savingDetail.name) {
//           final Map<String, dynamic> queryParameters = state!.queryParameters;
//           initDynamicLink();
//
//           if (user.role == '일반') {
//             ToastUtils.showToast(context,
//                 toastText: '추천인 또는 전문업체만 이용 가능한 페이지입니다.', margin: const EdgeInsets.only(bottom: kBottomNavigationBarHeight));
//             return;
//           }
//           context.pushNamed(routerName, queryParameters: queryParameters);
//           return;
//         }
//
//         /// 프로젝트 상세 페이지로 이동
//         if (routerName == AppRouter.projectDetail.name) {
//           final int projectId = int.parse(state!.queryParameters['projectId'] as String);
//           initDynamicLink();
//
//           if (user.role == '일반') {
//             ref.read(projectDetailProvider(id: projectId).future).then((project) {
//               if (project.userId != user.id) {
//                 ToastUtils.showToast(context, toastText: '본인 소유의 프로젝트만 접근 가능합니다.', margin: const EdgeInsets.only(bottom: kBottomNavigationBarHeight));
//                 return;
//               } else {
//                 context.pushNamed(routerName, extra: (projectId, null));
//               }
//             });
//             return;
//           } else {
//             context.pushNamed(routerName, extra: (projectId, null));
//             return;
//           }
//         }
//       } else {
//         ToastUtils.showToast(context, toastText: '회원만 이용 가능한 페이지입니다.', margin: const EdgeInsets.only(bottom: kBottomNavigationBarHeight));
//         context.pushNamed(AppRouter.auth.name);
//         return;
//       }
//     }
//     return;
//   }
// }
