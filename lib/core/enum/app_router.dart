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

  // Home Router
  home(path: '/home', name: 'home', subPath: 'home'),

  example2(path: '/example2', name: 'example2', subPath: 'example2'),
  exampleSub(path: '/example2/sub', name: 'exampleSub', subPath: 'exampleSub'),
  temp(path:'temp', name:'temp', subPath:'temp');

  const AppRouter({required this.path, required this.name, required this.subPath});

  final String path;
  final String name;
  final String subPath;
}

