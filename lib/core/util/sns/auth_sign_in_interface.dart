abstract class IAuthSignIn {
  /// sns 로그인한다.
  void signIn();
  /// sns 에서 로그아웃한다.
  void signOut();
  /// 유저 고유키를 가져온다.
  void getIdentifier();
  /// 로그인을 완전 해제한다.
  void withdrawal();
}