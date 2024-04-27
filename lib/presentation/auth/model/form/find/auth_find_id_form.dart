

import 'package:meditong/presentation/auth/enum/auth_enum.dart';

class AuthFindIdForm {
  final String? tel;

  /// 인증번호가 인증되었는지에 대한 여부에 대한 상태, 초기값: none
  final AuthVerificationNumberStatus verificationNumberStatus;

  AuthFindIdForm({
    this.tel,
    this.verificationNumberStatus = AuthVerificationNumberStatus.none,
  });

  AuthFindIdForm copyWith({
    String? tel,
    String? verificationNumber,
    AuthVerificationNumberStatus? verificationNumberStatus,
  }) {
    return AuthFindIdForm(
      tel: tel ?? this.tel,
      verificationNumberStatus: verificationNumberStatus ?? this.verificationNumberStatus,
    );
  }

  @override
  String toString() {
    return 'AuthFindIdForm{tel: $tel, verificationNumberStatus: $verificationNumberStatus}';
  }
}
