import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../auth_sign_in_interface.dart';

class AuthSignInApple implements IAuthSignIn {
  @override
  Future<String> getIdentifier() async {
    try {
      final appleMe = await SignInWithApple.getAppleIDCredential(scopes: []);
      final identifier = appleMe.userIdentifier;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('appleIdentifier', identifier!);

      return identifier.toString();
    } catch (err, stack) {
      throw Exception(stack.toString());
    }
  }

  @override
  Future<void> signIn() async {
    await SignInWithApple.getAppleIDCredential(scopes: []);
  }

  @override
  Future<void> signOut() async {
  }

  @override
  void withdrawal() {
  }

}