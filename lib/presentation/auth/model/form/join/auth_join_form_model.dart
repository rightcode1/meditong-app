import 'package:json_annotation/json_annotation.dart';

import '../../../enum/auth_enum.dart';

/// 서버로 API 를 요청하기 위해 필요한 데이터들이 포함된 Form Model.
@JsonSerializable()
class AuthJoinFormModel {
  final Map<String, dynamic> formData;

  // 현재 폼에 대한 메타 상태를 관리하기 위한 멤버 변수들

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
    final isLoginIdNotEmpty = formData['loginId'].toString().isNotEmpty;
    final isPasswordNotEmpty = formData['password'].toString().isNotEmpty;
    final isPasswordConfirmNotEmpty = formData['passwordConfirm'].toString().isNotEmpty;
    final isNameNotEmpty = formData['name'].toString().isNotEmpty;
    final isTelNotEmpty = formData['tel'].toString().isNotEmpty;
    final isVerificationNumberNotEmpty = formData['verificationNumber'].toString().isNotEmpty;

    if (isLoginIdNotEmpty &&
        isPasswordNotEmpty &&
        isPasswordConfirmNotEmpty &&
        isNameNotEmpty &&
        isTelNotEmpty &&
        isVerificationNumberNotEmpty &&
        (verificationNumberStatus == AuthVerificationNumberStatus.confirmed) &&
        isLoginIdVerified == AuthVerificationStatus.verified &&
        isPasswordVerified == AuthVerificationStatus.verified &&
        isPasswordConfirmVerified == AuthVerificationStatus.verified
    ) {
      return true;
    } else {
      return false;
    }
  }

  /// 일반 SNS 회원가입 검증 여부
  get isCommonSnsAllValidated {
    final isNameNotEmpty = formData['name'].toString().isNotEmpty;
    final isTelNotEmpty = formData['tel'].toString().isNotEmpty;
    final isVerificationNumberNotEmpty = formData['verificationNumber'].toString().isNotEmpty;

    if (isNameNotEmpty &&
        isTelNotEmpty &&
        isVerificationNumberNotEmpty &&
        (verificationNumberStatus == AuthVerificationNumberStatus.confirmed)) {
      return true;
    } else {
      return false;
    }
  }

  AuthJoinFormModel({
    this.formData = const {},
    this.verificationNumberStatus = AuthVerificationNumberStatus.none,
    this.isLoginIdVerified,
    this.isPasswordVerified,
    this.isPasswordConfirmVerified,
  });

  AuthJoinFormModel copyWith({
    Map<String, dynamic>? formData,
    AuthVerificationStatus? isLoginIdVerified,
    AuthVerificationStatus? isPasswordVerified,
    AuthVerificationStatus? isPasswordConfirmVerified,
    AuthVerificationNumberStatus? verificationNumberStatus,
  }) {
    return AuthJoinFormModel(
      formData: formData ?? this.formData,
      isLoginIdVerified: isLoginIdVerified ?? this.isLoginIdVerified,
      isPasswordVerified: isPasswordVerified ?? this.isPasswordVerified,
      isPasswordConfirmVerified: isPasswordConfirmVerified ?? this.isPasswordConfirmVerified,
      verificationNumberStatus: verificationNumberStatus ?? this.verificationNumberStatus,
    );
  }

  @override
  String toString() {
    return 'AuthJoinForm{formData: $formData, isLoginIdVerified: $isLoginIdVerified, verificationNumberStatus: $verificationNumberStatus}';
  }
}
