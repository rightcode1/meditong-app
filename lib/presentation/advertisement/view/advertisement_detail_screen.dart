import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediport/core/component/.etc/no_list_widget.dart';
import 'package:mediport/core/layout/default_layout.dart';
import 'package:mediport/service/advertisement/advertisement_providers.dart';

class AdvertisementDetailScreen extends ConsumerWidget {
  const AdvertisementDetailScreen({super.key, required this.advertisementId});

  final int advertisementId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final advertisementDetail = ref.watch(advertisementDetailProvider(advertisementId: advertisementId));
    return DefaultLayout(
      showAppBar: true,
      showBack: true,
      padding: EdgeInsets.zero,
      title: advertisementDetail.hasValue ? advertisementDetail.value!.title : '',
      child: advertisementDetail.when(
        data: (data) {
          return Column(
            children: [
              // TODO: 서버 작업 이후 S3 경로 제거 필요 (현재는 클라우드프론트 기준 상대 경로로 반환됨)
              CachedNetworkImage(
                imageUrl: 'https://meditong-images.s3.ap-northeast-2.amazonaws.com/${data.image!}',
              ),
            ],
          );
        },
        error: (error, stackTrace) => const Center(
          child: NoListWidget(text: '데이터를 불러오는 중 오류가 발생했습니다.'),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
