import 'package:json_annotation/json_annotation.dart';

import '../../../../../domain/model/auth/req/join/auth_req_join.dart';
import '../../../enum/auth_enum.dart';

/// 서버로 API 를 요청하기 위해 필요한 데이터들이 포함된 Form Model.
@JsonSerializable()
class AuthJoinFormModel {
  /// 로그인 아이디
  final String loginId;

  /// 비밀번호
  final String password;

  /// 비밀번호 확인
  final String passwordConfirm;

  /// 이름
  final String name;

  /// 휴대폰 번호
  final String tel;

  /// 인증번호
  final String telVerificationCode;

  /*
  *
  * 현재 폼에 대한 메타 상태를 관리하기 위한 멤버 변수들
  *
  * */

  /// 로그인 아이디 검증 여부
  final AuthVerificationStatus? isLoginIdVerified;

  /// 비밀번호 검증 여부
  final AuthVerificationStatus? isPasswordVerified;

  // /// 비밀번호 확인 검증 여부
  final AuthVerificationStatus? isPasswordConfirmVerified;

  /// 인증번호가 인증되었는지에 대한 여부에 대한 상태, 초기값: none
  final AuthVerificationNumberStatus verificationNumberStatus;

  /// 모든 값이 인증되었는지에 대한 여부
  get isCommonAllValidated {
    final isLoginIdNotEmpty = loginId.isNotEmpty;
    final isPasswordNotEmpty = password.isNotEmpty;
    final isPasswordConfirmNotEmpty = passwordConfirm.isNotEmpty;
    final isNameNotEmpty = name.isNotEmpty;
    final isTelNotEmpty = tel.isNotEmpty;
    final isVerificationNumberNotEmpty = telVerificationCode.isNotEmpty;

    return isLoginIdNotEmpty &&
        isPasswordNotEmpty &&
        isPasswordConfirmNotEmpty &&
        isNameNotEmpty &&
        isTelNotEmpty &&
        isVerificationNumberNotEmpty &&
        (verificationNumberStatus == AuthVerificationNumberStatus.confirmed) &&
        isLoginIdVerified == AuthVerificationStatus.verified &&
        isPasswordVerified == AuthVerificationStatus.verified &&
        isPasswordConfirmVerified == AuthVerificationStatus.verified;
  }

  /// 일반 SNS 회원가입 검증 여부
  get isCommonSnsAllValidated {
    final isNameNotEmpty = name.isNotEmpty;
    final isTelNotEmpty = tel.isNotEmpty;
    final isVerificationNumberNotEmpty = telVerificationCode.isNotEmpty;

    isNameNotEmpty &&
        isTelNotEmpty &&
        isVerificationNumberNotEmpty &&
        (verificationNumberStatus == AuthVerificationNumberStatus.confirmed);
  }

  AuthJoinFormModel({
    this.loginId = '',
    this.password = '',
    this.passwordConfirm = '',
    this.name = '',
    this.tel = '',
    this.telVerificationCode = '',
    this.verificationNumberStatus = AuthVerificationNumberStatus.none,
    this.isLoginIdVerified,
    this.isPasswordVerified,
    this.isPasswordConfirmVerified,
  });

  AuthJoinFormModel copyWith({
    String? loginId,
    String? password,
    String? passwordConfirm,
    String? name,
    String? tel,
    String? telVerificationCode,
    AuthVerificationStatus? isLoginIdVerified,
    AuthVerificationStatus? isPasswordVerified,
    AuthVerificationStatus? isPasswordConfirmVerified,
    AuthVerificationNumberStatus? verificationNumberStatus,
  }) {
    return AuthJoinFormModel(
      loginId: loginId ?? this.loginId,
      password: password ?? this.password,
      passwordConfirm: passwordConfirm ?? this.passwordConfirm,
      name: name ?? this.name,
      tel: tel ?? this.tel,
      telVerificationCode: telVerificationCode ?? this.telVerificationCode,
      isLoginIdVerified: isLoginIdVerified ?? this.isLoginIdVerified,
      isPasswordVerified: isPasswordVerified ?? this.isPasswordVerified,
      isPasswordConfirmVerified: isPasswordConfirmVerified ?? this.isPasswordConfirmVerified,
      verificationNumberStatus: verificationNumberStatus ?? this.verificationNumberStatus,
    );
  }

  /**
   * 모델을 Dto로 전환한다.
   */
  AuthReqJoin toDto() {
    return AuthReqJoin(
      loginId: loginId,
      password: password,
      name: name,
      tel: tel,
    );
  }

  @override
  String toString() {
    return 'AuthJoinFormModel{loginId: $loginId, password: $password, passwordConfirm: $passwordConfirm, name: $name, tel: $tel, telVerificationCode: $telVerificationCode, isLoginIdVerified: $isLoginIdVerified, isPasswordVerified: $isPasswordVerified, isPasswordConfirmVerified: $isPasswordConfirmVerified, verificationNumberStatus: $verificationNumberStatus}';
  }
}
