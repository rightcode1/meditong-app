import 'package:json_annotation/json_annotation.dart';

part 'version_req_update.g.dart';

@JsonSerializable(includeIfNull: false)
class VersionReqUpdate {
  final String? aosStoreVer;
  final String? iosStoreVer;

  VersionReqUpdate({
    this.aosStoreVer,
    this.iosStoreVer,
  });

  Map<String, dynamic> toJson() => _$VersionReqUpdateToJson(this);

  @override
  String toString() {
    return 'VersionReqUpdate{aosStoreVer: $aosStoreVer, iosStoreVer: $iosStoreVer}';
  }
}