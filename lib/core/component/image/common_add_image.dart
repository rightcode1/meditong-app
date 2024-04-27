import 'dart:io';
import 'package:meditong/core/constant/app_color.dart';
import 'package:meditong/core/util/toast_utils.dart';
import 'package:meditong/domain/model/base_image_res.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// 이미지+해시 모델
class ImageHashModel {
  final String md5Hash;
  final File imageFile;

  const ImageHashModel({
    required this.md5Hash,
    required this.imageFile,
  });

  /// XFile 리스트를 ImageHashModel 리스트로 변환한다.
  static Future<List<ImageHashModel>> convertXFileListIntoImageHashModelList({required List<XFile> xFileList}) async {
    if (xFileList.isEmpty) return <ImageHashModel>[];

    final List<ImageHashModel> imageHashModelList = <ImageHashModel>[];
    for (XFile xFile in xFileList) {
      final File file = File(xFile.path);
      final md5checksum = md5.convert(await file.readAsBytes());

      imageHashModelList.add(ImageHashModel(md5Hash: md5checksum.toString(), imageFile: file));
    }

    return imageHashModelList;
  }

  /// File 리스트를 ImageHashModel 리스트로 변환한다.
  static Future<List<ImageHashModel>> covertFileListIntoImageHashModelList({required List<File> fileList}) async {
    if (fileList.isEmpty) return <ImageHashModel>[];

    final List<ImageHashModel> imageHashModelList = <ImageHashModel>[];
    for (File file in fileList) {
      final md5checksum = md5.convert(await file.readAsBytes());

      imageHashModelList.add(ImageHashModel(md5Hash: md5checksum.toString(), imageFile: file));
    }

    return imageHashModelList;
  }
}

class CommonAddImage extends StatefulWidget {
  const CommonAddImage({
    super.key,
    this.resize,
    this.padding,
    this.physics,
    this.cacheExtent,
    this.addImageWidget,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.initialFileImages,
    this.initialNetworkImages,

    /// 필수값
    required this.crossAxisCount,
    required this.scrollDirection,
    required this.maxImageCount,

    /// Callback Functions
    this.onImageClicked,
    required this.onImageAdded,
    required this.onImageDeleted,
  });

  /// 네트워크 이미지 리사이즈
  final Size? resize;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;
  final double? cacheExtent;
  final Widget? addImageWidget;
  final double? mainAxisSpacing;
  final double? crossAxisSpacing;
  final List<File>? initialFileImages;
  final List<BaseImageRes>? initialNetworkImages;

  final int maxImageCount;
  final int crossAxisCount;
  final Axis scrollDirection;

  final Function(bool isNetworkImage)? onImageClicked;
  final Function(List<File> selectedImages) onImageAdded;
  final Function(File? deleteImage, BaseImageRes? deleteNetworkImage) onImageDeleted;

  @override
  State<CommonAddImage> createState() => _CommonAddImageState();
}

class _CommonAddImageState extends State<CommonAddImage> {
  /// 이미 선택한 이미지 리스트
  final List<ImageHashModel> _saveFileList = <ImageHashModel>[];

  /// 이미 저장된 네트워크 이미지 리스트
  List<BaseImageRes> _initialNetworkImages = <BaseImageRes>[];

  /// State 초기화
  Future<void> initData() async {
    if (widget.initialNetworkImages != null) {
      _initialNetworkImages = List.from(widget.initialNetworkImages!);
    }

    if (widget.initialFileImages != null) {
      _saveFileList.addAll(await ImageHashModel.covertFileListIntoImageHashModelList(fileList: widget.initialFileImages!));
    }

    setState(() {});
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  /// 이미지 선택 모드 위젯 (카메라, 앨범, 취소)
  Future<bool?> questionSelectMode() async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            width: 1.sw,
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            padding: EdgeInsets.symmetric(vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, true);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                    child: SizedBox(
                      width: 1.sw,
                      child: Text(
                        '사진 촬영하기',
                        style: TextStyle(fontSize: 16.spMin, fontWeight: FontWeight.w600, color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Divider(height: 1.h, color: AppColor.grey500),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, false);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                    child: SizedBox(
                      width: 1.sw,
                      child: Text(
                        '사진 앨범에서 선택',
                        style: TextStyle(fontSize: 16.spMin, fontWeight: FontWeight.w600, color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Divider(height: 1.h, color: AppColor.grey500),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, null);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                    child: SizedBox(
                      width: 1.sw,
                      child: Text(
                        '닫기',
                        style: TextStyle(fontSize: 16.spMin, fontWeight: FontWeight.w600, color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    return result;
  }

  /// 이미지 아이템 위젯
  Widget buildImageItem({
    required String imagePath,
    required bool isNetworkImage,
    required Function() onImageDeleted,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: Material(
        child: Stack(
          children: [
            /// 이미지
            Ink.image(
              width: 1.sw,
              height: 1.sh,
              fit: BoxFit.cover,
              image: isNetworkImage
                  ? CachedNetworkImageProvider(imagePath)
                  : FileImage(File(imagePath)) as ImageProvider,
              child: InkWell(
                splashColor: Colors.grey.withOpacity(0.4),
                highlightColor: Colors.grey.withOpacity(0.4),

                /// 이미지 클릭 이벤트
                onTap: widget.onImageClicked != null
                    ? () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        widget.onImageClicked!(isNetworkImage);
                      }
                    : null,
              ),
            ),

            /// 이미지 삭제 버튼
            Positioned(
              top: 5.w,
              right: 5.w,
              child: ClipOval(
                child: Material(
                  child: InkWell(
                    splashColor: Colors.white.withOpacity(0.2),
                    highlightColor: Colors.white.withOpacity(0.2),
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      onImageDeleted();
                    },
                    child: Ink(
                      width: 22.w,
                      height: 22.w,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.clear_outlined, color: Colors.white, size: 16.w),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: widget.physics ?? const NeverScrollableScrollPhysics(),
      padding: widget.padding ?? EdgeInsets.symmetric(horizontal: 2.w),
      cacheExtent: widget.cacheExtent ?? 2000,
      mainAxisSpacing: widget.mainAxisSpacing ?? 15.w,
      crossAxisSpacing: widget.crossAxisSpacing ?? 12.h,
      crossAxisCount: widget.crossAxisCount,
      scrollDirection: widget.scrollDirection,
      children: [
        /// 이미지 추가 버튼
        Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: const [BoxShadow(color: AppColor.grey300, blurRadius: 12)],
          ),
          child: InkWell(
            onTap: () async {
              /// 키보드 포커스 해제
              FocusManager.instance.primaryFocus?.unfocus();

              /// 최대 선택 가능한 이미지 갯수 체크
              final availableCount = widget.maxImageCount - (_saveFileList.length + _initialNetworkImages.length);
              if (availableCount < 1) {
                ToastUtils.showToast(context, toastText: '최대 ${widget.maxImageCount}개 까지 등록 가능합니다.');
                return;
              }

              /// 이미지 선택 모드
              final selectMode = await questionSelectMode();

              /// 이미지 모드 선택 취소
              if (selectMode == null) return;

              /// 이미지 선택 결과 (앨범, 카메라)
              List<XFile> xFileList = [];

              if (selectMode == true) {
                /// 카메라로 이미지 촬영
                final cameraImage = await ImagePicker().pickImage(source: ImageSource.camera);

                /// 이미지 촬영 취소
                if (cameraImage == null) return;

                /// 이미지 촬영 결과를 저장
                xFileList = [cameraImage];
              } else if (selectMode == false) {
                /// 앨범에서 이미지 선택
                final List<XFile> selectImages = await ImagePicker().pickMultiImage(requestFullMetadata: true);

                /// 선택한 이미지가 없을 경우 선택 취소
                if (selectImages.isEmpty) return;

                xFileList = selectImages;
              }

              //// 선택한 이미지 ImageHashModel 로 변환 (XFile -> ImageHashModel)
              final imageHashList = await ImageHashModel.convertXFileListIntoImageHashModelList(xFileList: xFileList);

              /// 이미 선택한 이미지와 선택한 이미지의 중복된 이미지 제거
              for (ImageHashModel saveFile in _saveFileList) {
                imageHashList.removeWhere((element) => element.md5Hash == saveFile.md5Hash);
              }

              /// 최대 선택 가능한 이미지 갯수 만큼 선택한 이미지를 저장
              for (int index = 0; index < imageHashList.length; index++) {
                if (index >= availableCount) {
                  break;
                }
                _saveFileList.add(imageHashList[index]);
              }

              /// 저장한 결과를 반영.
              setState(() {});

              /// 저장한 이미지를 File 리스트로 변환하여 콜백
              final List<File> saveFileList = _saveFileList.map((image) => image.imageFile).toList();
              widget.onImageAdded(saveFileList);
            },
            borderRadius: BorderRadius.circular(10.r),
            child: widget.addImageWidget ??
                Center(
                  child: SizedBox(
                    width: 100.h,
                    height: 100.h,
                    child: Image.asset('assets/images/common/add_image_button_white@3x.png', fit: BoxFit.cover),
                  ),
                ),
          ),
        ),

        /// 기존 저장된 네트워크 이미지 리스트
        ..._initialNetworkImages.mapIndexed(
          (index, networkImage) => buildImageItem(
            imagePath: networkImage.name,
            isNetworkImage: true,
            onImageDeleted: () {
              _initialNetworkImages.removeAt(index);
              setState(() {});
              widget.onImageDeleted(null, networkImage);
            },
          ),
        ),

        /// 앨범을 통해 선택된 이미지 리스트
        ..._saveFileList.mapIndexed(
          (index, file) => buildImageItem(
            imagePath: file.imageFile.path,
            isNetworkImage: false,
            onImageDeleted: () {
              _saveFileList.removeAt(index);
              setState(() {});
              widget.onImageDeleted(file.imageFile, null);
            },
          ),
        ),
      ],
    );
  }
}
