import 'package:mediport/presentation/auth/enum/auth_enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_find_password_form.g.dart';

@JsonSerializable()
class AuthFindPasswordForm {
  final String? loginId;
  final String? tel;
  final String? password;

  /// 인증번호가 인증되었는지에 대한 여부에 대한 상태, 초기값: none
  final AuthVerificationNumberStatus verificationNumberStatus;

  /// 비밀번호 사용 가능 여부
  final AuthVerificationStatus verificationStatusOfPassword;

  /// 비밀번호 일치 여부
  final AuthVerificationStatus verificationStatusOfPasswordConfirm;

  bool get canUpdatePassword {
    final validLoginId = loginId != null && loginId!.isNotEmpty;
    final validVerified = verificationNumberStatus == AuthVerificationNumberStatus.confirmed;

    return validLoginId && validVerified;
  }

  AuthFindPasswordForm({
    this.loginId,
    this.tel,
    this.password,
    this.verificationNumberStatus = AuthVerificationNumberStatus.none,
    this.verificationStatusOfPassword = AuthVerificationStatus.none,
    this.verificationStatusOfPasswordConfirm = AuthVerificationStatus.none,
  });

  AuthFindPasswordForm copyWith({
    String? loginId,
    String? tel,
    String? password,
    String? verificationNumber,
    AuthVerificationNumberStatus? verificationNumberStatus,
    AuthVerificationStatus? verificationStatusOfPassword,
    AuthVerificationStatus? verificationStatusOfPasswordConfirm,
  }) {
    return AuthFindPasswordForm(
      loginId: loginId ?? this.loginId,
      tel: tel ?? this.tel,
      password: password == '-1' ? null : password ?? this.password,
      verificationNumberStatus: verificationNumberStatus ?? this.verificationNumberStatus,
      verificationStatusOfPassword: verificationStatusOfPassword ?? this.verificationStatusOfPassword,
      verificationStatusOfPasswordConfirm: verificationStatusOfPasswordConfirm ?? this.verificationStatusOfPasswordConfirm,
    );
  }

  Map<String, dynamic> toJson() => _$AuthFindPasswordFormToJson(this);

  @override
  String toString() {
    return 'AuthFindPasswordForm{loginId: $loginId, tel: $tel, password: $password, verificationNumberStatus: $verificationNumberStatus, verificationStatusOfPassword: $verificationStatusOfPassword, verificationStatusOfPasswordConfirm: $verificationStatusOfPasswordConfirm}';
  }
}
