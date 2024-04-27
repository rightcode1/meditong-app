import 'dart:io';
import 'package:meditong/core/util/toast_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../constant/data.dart';

class _ComputeData {
  final RootIsolateToken token;
  final String url;
  final String path;

  const _ComputeData({
    required this.token,
    required this.url,
    required this.path,
  });
}

Future<bool> downloadImage(_ComputeData data) async {
  BackgroundIsolateBinaryMessenger.ensureInitialized(data.token);
  try {
    debugPrint('Download Compute Start');
    await Dio().download(data.url, data.path);
    await Gal.putImage(data.path, album: 'buildhada');
    debugPrint('Download Compute End');
    return true;
  } on GalException catch (e) {
    debugPrint(e.type.message);
    return false;
  }
}

Future<void> downloadImageCompute({required _ComputeData data, required BuildContext context}) async {
  final result = await compute(downloadImage, data);
  debugPrint('Compute Result : $result');

  await Fluttertoast.cancel();
  await Future.delayed(const Duration(milliseconds: 500));
  if (context.mounted) {
    ToastUtils.showToast(context, toastText: result ? '다운로드가 완료되었습니다.' : '다운로드 중 오류가 발생했습니다.');
  } else {
    ToastUtils.showToastNoContext(msg: result ? '다운로드가 완료되었습니다.' : '다운로드 중 오류가 발생했습니다.');
  }
}

class GalleryPhotoViewWrapper extends StatefulWidget {
  GalleryPhotoViewWrapper({
    this.loadingBuilder,
    this.backgroundDecoration,
    this.closeBtnColor,
    this.useImageDownload = false,
    this.minScale,
    this.maxScale,
    this.initialIndex = 0,
    required this.galleryItems,
    this.scrollDirection = Axis.horizontal,
    super.key,
  }) : pageController = PageController(initialPage: initialIndex);

  final LoadingBuilder? loadingBuilder;
  final BoxDecoration? backgroundDecoration;
  final Color? closeBtnColor;
  final bool useImageDownload;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<String> galleryItems;
  final Axis scrollDirection;

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }

  static void open({
    required BuildContext context,
    required final int index,
    required List<String> images,
    Color? backgroundColor,
    Color? closeBtnColor,
    bool useImageDownload = false,
  }) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
          return GalleryPhotoViewWrapper(
            useImageDownload: useImageDownload,
            galleryItems: images,
            backgroundDecoration: BoxDecoration(
              color: backgroundColor ?? Colors.black,
            ),
            closeBtnColor: closeBtnColor,
            initialIndex: index,
          );
        },
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> with TickerProviderStateMixin {
  late int currentIndex = widget.initialIndex;
  late AnimationController _fadeController;

  /// Background Isloate 로부터 전달받을 포트
  // final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    _fadeController = AnimationController(vsync: this);

    /// [widget.useImageDownload] 가 true 일 경우, Background Isolate 로부터 전달받을 로직 정의
    // if (widget.useImageDownload) {
    //   IsolateNameServer.registerPortWithName(_port.sendPort, 'build_image_download');
    //   _port.listen((dynamic data) {
    //     DownloadTaskStatus status = DownloadTaskStatus.fromInt(data[1]);
    //
    //     if (status == DownloadTaskStatus.complete) {
    //       debugPrint('Complete _fileName : $_fileName');
    //       ToastUtils.showToast(context, toastText: '다운로드가 완료되었습니다.');
    //     }
    //   });
    //
    //   FlutterDownloader.registerCallback(downloadCallback);
    // }

    super.initState();
  }

  /// 다운로드 완료 시 콜백
  ///
  /// UI 는 메인 Isolate 이며, 다운로드 완료 시의 콜백은 Background Isolate 이다.
  /// 따라서, 다운로드 완료 시 해당 콜백을 UI 의 리스너를 통해 해당 콜백의 결과를 넘겨받을 수 있도록 처리한다.
  // @pragma('vm:entry-point')
  // static void downloadCallback(String id, int status, int progress) {
  //   final SendPort? send = IsolateNameServer.lookupPortByName('build_image_download');
  //   send?.send([id, status, progress]);
  // }

  @override
  void dispose() {
    Fluttertoast.cancel();
    // IsolateNameServer.removePortNameMapping('build_image_download');
    _fadeController.dispose();
    super.dispose();
  }

  void onPageChanged(int index) async {
    await Fluttertoast.cancel();

    if (!context.mounted) return;
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: widget.backgroundDecoration,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: SafeArea(
          child: Stack(
            alignment: Alignment.topRight,
            children: <Widget>[
              Column(
                children: [
                  SizedBox(height: 20.0.h),
                  Expanded(
                    child: PhotoViewGallery.builder(
                      scrollPhysics: const BouncingScrollPhysics(),
                      builder: _buildItem,
                      itemCount: widget.galleryItems.length,
                      loadingBuilder: widget.loadingBuilder,
                      backgroundDecoration: widget.backgroundDecoration,
                      pageController: widget.pageController,
                      onPageChanged: onPageChanged,
                      scrollDirection: widget.scrollDirection,
                      allowImplicitScrolling: true,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.useImageDownload) ...[
                      InkWell(
                        onTap: () async {
                          ToastUtils.showToast(context, toastText: '다운로드가 시작되었습니다.');

                          // String savePath = (await getApplicationSupportDirectory()).path;

                          final downloadUrl = '$S3_IMAGE_HOST${widget.galleryItems[currentIndex]}';
                          final saveFilePath =
                              '${(await getApplicationSupportDirectory()).path}/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg';

                          // await FlutterDownloader.enqueue(
                          //   url: Uri.parse(uri)'$CLOUD_FORNT_IMAGE_HOST${filter.ImageFilter.maximumQuality.filter}${widget.galleryItems[currentIndex]}',
                          //   savedDir: '$savePath/',
                          //   fileName: saveFileName,
                          //   showNotification: true,
                          //   saveInPublicStorage: true,
                          //   // show download progress in status bar (for Android)
                          //   openFileFromNotification: true, // click on notification to open downloaded file (for Android)
                          // );

                          if (!context.mounted) return;

                          downloadImageCompute(
                              data: _ComputeData(token: RootIsolateToken.instance!, url: downloadUrl, path: saveFilePath), context: context);
                        },
                        child: Icon(
                          Icons.save_alt,
                          color: widget.closeBtnColor ?? Colors.white,
                          size: 25.h,
                        ),
                      ),
                      SizedBox(width: 10.0.w),
                    ],
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close,
                        color: widget.closeBtnColor ?? Colors.white,
                        size: 25.h,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final String item = widget.galleryItems[index];
    debugPrint(item);
    return PhotoViewGalleryPageOptions.customChild(
      heroAttributes: PhotoViewHeroAttributes(
        tag: "$index",
        transitionOnUserGestures: true,
      ),
      child: Dismissible(
        key: Key(item.hashCode.toString()),
        direction: DismissDirection.vertical,
        onUpdate: (details) {
          _fadeController.value = details.progress;
        },
        resizeDuration: const Duration(milliseconds: 10),
        // reduces the time to call 'onDismissed'
        onDismissed: (direction) {
          Navigator.pop(context);
        },
        child: PhotoView(
          imageProvider: item.startsWith('images/') ||
              item.startsWith('conceptImages/') ||
              item.startsWith('project/') ||
              item.startsWith('portfolio/') ||
              item.startsWith('portfolioContent/') ||
              item.startsWith('saving/') ||
              item.startsWith('bid/')
              ? NetworkImage('$S3_IMAGE_HOST$item')
              : Image.file(File(item)).image,
          tightMode: true,
          initialScale: PhotoViewComputedScale.contained,
          backgroundDecoration: const BoxDecoration(color: Colors.transparent),
          // heroAttributes: PhotoViewHeroAttributes(
          //   tag: "${item.id}",
          //   transitionOnUserGestures: true,
          // ),
          // minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
          // maxScale: PhotoViewComputedScale.covered * 4.1,
          minScale: PhotoViewComputedScale.contained,
          // maxScale: PhotoViewComputedScale.covered,
        ),
      ),
    );
  }
}
