/// AppRouter 정의
/// [path] - path 는 절대적 경로를 정의한다.
/// [name] - name 는 router 의 name 을 정의한다.
/// [name] - enum 에 정의한 값과 동일하게 설정한다(GoRouter relative path 로 활용되기 때문).
enum AppRouter {

  /// Splash Router
  splash(path: '/splash', name: 'splash', subPath: 'splash'),

  /// WebView Router
  webviewTerm(path: '/webview/term', name: 'webviewTerm', subPath: 'term'),

  /// Auth Router
  auth(path: '/auth', name: 'auth', subPath: 'auth'),
  join(path: '/auth/join', name: 'join', subPath: 'join'),
  findId(path: '/auth/findId', name: 'findId', subPath: 'findId'),
  findPassword(path: '/auth/findPassword', name: 'findPassword', subPath: 'findPassword'),
  findPasswordUpdate(path: '/auth/findPassword/update', name: 'findPasswordUpdate', subPath: 'findPasswordUpdate'),

  // Home Router
  home(path: '/home', name: 'home', subPath: 'home'),

  // 홈 > 알림(Alert) 라우터
  alert(path: '/home/alert', name: 'alert', subPath: 'alert'),
  alertRegister(path: '/home/alert/register', name: 'alertRegister', subPath: 'register'),

  // 홈 > 광고 라우터
  advertisementDetail(path: '/home/advertisement/detail', name: 'advertisementDetail', subPath: 'advertisement/detail'),

  // 홈 > 마이 라우터
  my(path: '/home/my', name: 'homeMy', subPath: 'my'),
  notice(path: '/home/my/notice', name: 'homeMyNotice', subPath: 'my/notice'),
  noticeDetail(path: '/home/my/notice/detail', name: 'homeMyNoticeDetail', subPath: 'my/notice/detail'),
  inquiry(path: '/home/my/inquiry', name: 'homeMyInquiry', subPath: 'my/inquiry'),
  inquiryDetail(path: '/home/my/inquiry/detail', name: 'homeMyInquiryDetail', subPath: 'my/inquiry/detail'),
  inquiryRegister(path: '/home/my/inquiry/register', name: 'homeMyInquiryRegister', subPath: 'my/inquiry/register'),

  // 경영/장비 게시글 리스트 라우터
  contents(path: '/contents', name: 'contents', subPath: 'contents'),
  contentsDetail(path: '/contents/detail', name: 'contentsDetail', subPath: 'contents/detail'),

  example2(path: '/example2', name: 'example2', subPath: 'example2'),
  exampleSub(path: '/example2/sub', name: 'exampleSub', subPath: 'exampleSub'),
  temp(path:'temp', name:'temp', subPath:'temp');

  const AppRouter({required this.path, required this.name, required this.subPath});

  final String path;
  final String name;
  final String subPath;
}

