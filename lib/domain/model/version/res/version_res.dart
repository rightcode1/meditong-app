import 'package:json_annotation/json_annotation.dart';

part 'version_res.g.dart';

@JsonSerializable()
class VersionRes {
  final int aosVer;
  final int iosVer;
  final int iosSocialVer;
  final int aosSocialVer;
  final String aosStoreVer;
  final String iosStoreVer;

  VersionRes({
    required this.aosVer,
    required this.iosVer,
    required this.iosSocialVer,
    required this.aosSocialVer,
    required this.aosStoreVer,
    required this.iosStoreVer,
  });

  factory VersionRes.fromJson(Map<String, dynamic> json) => _$VersionResFromJson(json);
}
