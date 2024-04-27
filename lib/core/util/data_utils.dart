import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class DataUtils {
  /// AssetEntity 를 MultipartFile 로 변환한다.
  static Future<File> convertAssetEntityIntoFile(
      AssetEntity entity,
      ) async {
    final file = await entity.file;
    if (file == null) {
      throw StateError('Unable to obtain file of the entity ${entity.id}.');
    }
    return file;
  }

  /// AssetEntity 를 파일 리스트로 변환한다.
  static Future<List<File>> convertAssetEntityListIntoFileList(List<AssetEntity> assetEntityList) async {
    final simultaneouslyFutureList = <Future<File>>[];
    for (AssetEntity eachAssetEntity in assetEntityList) {
      simultaneouslyFutureList.add(DataUtils.convertAssetEntityIntoFile(eachAssetEntity));
    }

    return await Future.wait(simultaneouslyFutureList);
  }

  /// 천 단위 콤마 포매팅을 위한 메소드
  static String convertNumericIntoCommaFormatted({required int numberToBeFormatted}) {
    final NumberFormat numberFormat = NumberFormat('###,###');
    return numberFormat.format(numberToBeFormatted);
  }

  /// 기본 BoxShadow 를 반환한다.
  static List<BoxShadow> getCommonBoxShadow() {
    return [
      BoxShadow(color: Colors.grey.shade100, blurRadius: 5, spreadRadius: 0.5),
    ];
  }

  /// 휴대폰 번호에 하이픈을 추가한다.
  static String convertNonDashedTelIntoDashed(String nonDashedTel) {
    return nonDashedTel.replaceAllMapped(RegExp(r'(\d{3})(\d{3,4})(\d{4})'), (m) => '${m[1]}-${m[2]}-${m[3]}');
  }
}
