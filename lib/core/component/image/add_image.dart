import 'dart:io';

import 'package:meditong/domain/model/base_image_res.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:meditong/core/component/delegate/korean_asset_picker_delegate.dart';
import 'package:meditong/core/component/delegate/korean_camera_picker_delegate.dart';
import 'package:meditong/core/component/image/image_container.dart';
import 'package:meditong/core/enum/add_image_element_mode.dart';
import 'package:meditong/core/util/data_utils.dart';
import 'package:meditong/core/util/toast_utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

@Deprecated('common_add_image.dart 를 사용하세요. 해당 버전은 구버전입니다. 추후 업데이트 시 삭제될 수 있습니다.')
class AddImage extends StatefulWidget {
  /// 이미지 추가 컴포넌트
  ///
  /// WeChat 패키지의 [AssetPicker] 를 활용한다.
  /// 좌측의 이미지 추가 이미지 버튼을 통해 이미지를 추가할 수 있다.
  /// 전체 이미지 개수인 [totalImageCount] 를 전달받는다. 기본값은 6장이다.
  /// 이미지를 추가하는 즉시, 추가되는 이미지에 대한 [File] 리스트를 반환하는 [onImageAdded] 콜백을 전달받는다.
  ///
  /// 게시글 수정과 같은 상황에서도 사용할 수 있다.
  /// 기존 서버에서 불러온 이미지인 [List<ImageRes>] 형태의 [initialImageNetworkSrcList] 를 전달받을 수 있다.
  /// 해당 이미지 Src 리스트는 [totalImageCount] 에 합산된다.
  ///
  /// 이미지 삭제 시, 삭제된 이미지 콜백인 [onImageDeleted] 를 통해 삭제된 이미지인 [File] 과 서버에서 불러온 이미지가 삭제되었을 경우, 해당 이미지에 대한 이미지 객체인 [ImageRes] 를 반환한다.
  ///
  /// 2023.08.30 업데이트
  /// GridView 로 변경
  /// [crossAxisCount] 한줄에 보여질 이미지 갯수
  /// [padding] GridView 의 padding
  /// [mainAxisSpacing] GridView 의 위아래 간격
  /// [crossAxisSpacing] GridView 의 좌우 간격
  ///
  /// 2023.11.14. 업데이트
  /// [mode] 를 통해 카메라/앨범 모드 선택 가능
  AddImage({
    this.mode = AddImageElementMode.album,
    this.totalImageCount = 6,
    this.initialImageNetworkSrcList = const [],
    required this.onImageAdded,
    required this.onImageDeleted,
    this.crossAxisCount = 3,
    this.padding = EdgeInsets.zero,
    this.mainAxisSpacing = 14.0,
    this.crossAxisSpacing = 14.5,
    Key? key,
  }) : super(key: key);

  final AddImageElementMode mode;
  final int totalImageCount;
  final List<BaseImageRes> initialImageNetworkSrcList;
  final void Function(List<File> selectedImages) onImageAdded;
  final void Function(File? deletedImage, BaseImageRes? deletedImageNetworkSrc) onImageDeleted;
  int? crossAxisCount;
  EdgeInsets? padding;
  double? mainAxisSpacing;
  double? crossAxisSpacing;

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  AddImageElementMode get _mode => widget.mode;

  int get _totalImageCount => widget.totalImageCount;

  late final List<BaseImageRes> _initialImageNetworkSrcList;

  void Function(List<File> selectedImages) get _onImageAdded => widget.onImageAdded;

  void Function(File? deletedImage, BaseImageRes? deletedImageNetworkSrc) get _onImageDeleted => widget.onImageDeleted;

  int get _crossAxisCount => widget.crossAxisCount!;

  EdgeInsets get _padding => widget.padding!;

  double get _mainAxisSpacing => widget.mainAxisSpacing!;

  double get _crossAxisSpacing => widget.crossAxisSpacing!;

  /// 선택된 AssetEntity 리스트
  List<AssetEntity> _selectedAssetImages = [];

  /// 선택된 AssetEntity 를 File 로 변환한 리스트
  List<File> _selectedFileImages = [];

  /// 서버로부터 불러온 이미지 개수
  late int _initialImageNetworkSrcCount;

  @override
  void initState() {
    super.initState();

    _initialImageNetworkSrcList = List.from(widget.initialImageNetworkSrcList);
    _initialImageNetworkSrcCount = _initialImageNetworkSrcList.length;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: _crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: _padding,
      mainAxisSpacing: _mainAxisSpacing.h,
      crossAxisSpacing: _crossAxisSpacing.w,
      children: [
        GestureDetector(
          onTap: () async {
            if (_initialImageNetworkSrcCount == _totalImageCount) {
              ToastUtils.showToast(context, toastText: '이미지를 추가할 수 없습니다. $_initialImageNetworkSrcCount/$_totalImageCount');
              return;
            }

            if (_mode == AddImageElementMode.album) {
              final selectedAssetImages = await AssetPicker.pickAssets(
                context,
                pickerConfig: AssetPickerConfig(
                  textDelegate: const KoreanAssetPickerTextDelegate(),
                  selectedAssets: _selectedAssetImages,
                  maxAssets: _totalImageCount - _initialImageNetworkSrcCount,
                  requestType: RequestType.image,
                ),
              );

              if (selectedAssetImages != null) {
                // selectedAssetImages 중, gif 파일이 존재할 경우, 제거한 후 토스트 창을 출력한다.
                List<AssetEntity> filteredGifFileList = selectedAssetImages.where((element) => (element.mimeType ?? 'image') == 'image/gif').toList();

                if (context.mounted && filteredGifFileList.isNotEmpty) {
                  ToastUtils.showToast(context, toastText: 'GIF 파일은 업로드 할 수 없습니다.');
                  selectedAssetImages.removeWhere((element) => filteredGifFileList.contains(element));
                }

                _selectedAssetImages = List.from(selectedAssetImages);
                _selectedFileImages = await DataUtils.convertAssetEntityListIntoFileList(_selectedAssetImages);

                _onImageAdded(_selectedFileImages);
              }
            } else {
              final selectedAssetImages = await CameraPicker.pickFromCamera(
                context,
                pickerConfig: CameraPickerConfig(
                  textDelegate: KoreanCameraPickerDelegate(),
                ),
              );

              if (selectedAssetImages != null) {
                _selectedAssetImages = List.from([..._selectedAssetImages, selectedAssetImages]);
                _selectedFileImages = await DataUtils.convertAssetEntityListIntoFileList(_selectedAssetImages);

                _onImageAdded(_selectedFileImages);
              }
            }

            setState(() {});
          },
          child: Image.asset(
            'assets/images/common/add_image_white@3x.png',
          ),
        ),
        /*
          서버로부터 불러온 이미지 렌더링
         */
        ..._initialImageNetworkSrcList
            .mapIndexed(
              (index, eachInitialImageNetworkSrc) => ImageContainer(
            fromNetwork: true,
            imagePath: eachInitialImageNetworkSrc.name,
            closeButtonPressed: () {
              _initialImageNetworkSrcList.remove(eachInitialImageNetworkSrc);
              _onImageDeleted(null, eachInitialImageNetworkSrc);

              _initialImageNetworkSrcCount--;
              setState(() {});
            },
          ),
        )
            .toList(),

        /*
          AssetPicker 를 통해 불러온 이미지 렌더링
         */
        ..._selectedFileImages.mapIndexed(
              (index, eachImageFile) => ImageContainer(
            imagePath: eachImageFile.path,
            closeButtonPressed: () {
              /// 현재 제거된 이미지의 인덱스에 대하여 각각 _selectedAssetImages 와 _selectedFileImages 에서 제거한다.
              _selectedAssetImages.removeAt(index);
              _selectedFileImages.removeAt(index);

              _onImageDeleted(eachImageFile, null);

              setState(() {});
            },
          ),
        ),
      ],
    );
  }
}
