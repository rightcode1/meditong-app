import 'package:json_annotation/json_annotation.dart';

part 'advertisement_res_detail.g.dart';

@JsonSerializable()
class AdvertisementResDetail {
  final int id;
  final String title;
  final String diff;
  final String location;
  final String? url;
  final String? thumbnail;
  final String? thumbnailOne;
  final bool active;
  final String createdAt;
  final int sortCode;
  final String? image;
  final int viewCount;
  final int? dataId;

  AdvertisementResDetail({
    required this.id,
    required this.title,
    required this.diff,
    required this.location,
    required this.url,
    required this.thumbnail,
    required this.thumbnailOne,
    required this.active,
    required this.createdAt,
    required this.sortCode,
    required this.image,
    required this.viewCount,
    required this.dataId,
  });

  AdvertisementResDetail copyWith({
    int? id,
    String? title,
    String? diff,
    String? location,
    String? url,
    String? thumbnail,
    String? thumbnailOne,
    bool? active,
    String? createdAt,
    int? sortCode,
    String? image,
    int? viewCount,
    int? dataId,
  }) =>
      AdvertisementResDetail(
        id: id ?? this.id,
        title: title ?? this.title,
        diff: diff ?? this.diff,
        location: location ?? this.location,
        url: url ?? this.url,
        thumbnail: thumbnail ?? this.thumbnail,
        thumbnailOne: thumbnailOne ?? this.thumbnailOne,
        active: active ?? this.active,
        createdAt: createdAt ?? this.createdAt,
        sortCode: sortCode ?? this.sortCode,
        image: image ?? this.image,
        viewCount: viewCount ?? this.viewCount,
        dataId: dataId ?? this.dataId,
      );

  factory AdvertisementResDetail.fromJson(Map<String, dynamic> json) => _$AdvertisementResDetailFromJson(json);

  @override
  String toString() {
    return 'AdvertisementResDetail{id: $id, title: $title, diff: $diff, location: $location, url: $url, thumbnail: $thumbnail, thumbnailOne: $thumbnailOne, active: $active, createdAt: $createdAt, sortCode: $sortCode, image: $image, viewCount: $viewCount, dataId: $dataId}';
  }
}
