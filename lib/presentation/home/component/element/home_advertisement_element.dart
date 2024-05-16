import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediport/core/component/.etc/no_list_widget.dart';
import 'package:mediport/core/component/carousel/image_carousel.dart';
import 'package:mediport/core/enum/app_router.dart';
import 'package:mediport/core/util/toast_utils.dart';
import 'package:mediport/service/advertisement/advertisement_providers.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeAdvertisementElement extends ConsumerWidget {
  const HomeAdvertisementElement({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final advertisementList = ref.watch(advertisementListProvider(location: '메인', active: true));
    return advertisementList.when(
      data: (data) {
        if (data.isEmpty) return const SizedBox();

        return ImageCarousel(
          height: 300.0.h,
          itemHeight: 300.0.h,
          itemList: data
              .map((e) => GestureDetector(
                    onTap: () {
                      if (e.diff == 'url') {
                        launchUrl(Uri.parse(e.url!));
                      } else if (e.diff == '이미지') {
                        context.pushNamed(AppRouter.advertisementDetail.name, queryParameters: {
                          'advertisementId': e.id.toString(),
                        });
                      } else {
                        ToastUtils.showToast(context, toastText: '정의되지 않은 광고 구분입니다. 개발자에게 문의하세요.');
                      }
                    },
                    child: Stack(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: CachedNetworkImage(
                            imageUrl: e.thumbnail!,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.transparent,
                                Colors.black.withOpacity(0.5),
                              ],
                            ),
                          ),
                        ),
                        Positioned.fill(
                          bottom: 16.0.h,
                          left: 16.0.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                e.title,
                                style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
                              ),
                              SizedBox(height: 8.0.h),
                              Text(
                                '비침습적 기기 텍스트 퍼블리싱... API 프로퍼티 필요...',
                                style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 11.0.sp, fontWeight: FontWeight.w600, color: Colors.white),
                              ),
                              // Text(e.),
                            ],
                          ),
                        )
                      ],
                    ),
                  ))
              .toList(),
        );
      },
      error: (error, stackTrace) => const Center(child: NoListWidget(text: '데이터를 불러오는 중 오류가 발생했습니다.')),
      loading: () => const SizedBox(),
    );
  }
}
