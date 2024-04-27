import 'package:flutter_naver_login/flutter_naver_login.dart';

import '../auth_sign_in_interface.dart';

class AuthSignInNaver implements IAuthSignIn {
  @override
  Future<String> getIdentifier() async {
    try {
      final naverMe = await FlutterNaverLogin.currentAccount();
      final identifier = naverMe.id;

      return identifier.toString();
    } catch (err, stack) {
      throw Exception(stack.toString());
    }
  }

  @override
  Future<void> signIn() async {
    await FlutterNaverLogin.logIn();
  }

  @override
  Future<void> signOut() async {
    await FlutterNaverLogin.logOut();
  }

  @override
  void withdrawal() async {
    await FlutterNaverLogin.logOutAndDeleteToken();
  }

}