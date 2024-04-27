import 'package:meditong/core/constant/app_color.dart';
import 'package:meditong/core/layout/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermWebView extends StatefulWidget {
  static get routeName => 'TermWebView';

  /// 웹뷰 형태의 약관을 렌더링하기 위한 스크린
  const TermWebView({
    required this.termTitle,
    required this.termUrl,
    Key? key,
  }) : super(key: key);

  final String termTitle;
  final String termUrl;

  @override
  State<TermWebView> createState() => _TermWebViewState();
}

class _TermWebViewState extends State<TermWebView> {
  String get _termTitle => widget.termTitle;

  String get _termUrl => widget.termUrl;

  late final WebViewController _webViewController;

  @override
  void initState() {
    super.initState();

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (request) {
          return NavigationDecision.navigate;
        },
      ))
      ..loadRequest(Uri.parse(_termUrl));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      showAppBar: true,
      showBack: true,
      title: _termTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _termTitle,
            style: TextStyle(fontSize: 18.0.sp, fontWeight: FontWeight.w700, color: AppColor.darkGrey500),
          ),
          SizedBox(height: 13.0.h),
          Divider(color: AppColor.grey400, height: 0.0, thickness: 1.0.w),
          Expanded(child: WebViewWidget(controller: _webViewController)),
        ],
      ),
    );
  }
}
