import 'package:json_annotation/json_annotation.dart';

/// Auth 관련된 Enum 파일

/// 핸드폰 인증번호 발송 API (auth/certificationNumberSMS) 호출 시 필요한 diff enum
enum AuthDiff {
  @JsonValue('join') join('join'),
  @JsonValue('find') find('find'),
  @JsonValue('update') update('update'),
  /// 자녀로 로그인
  @JsonValue('login') login('login');

  const AuthDiff(this.type);
  final String type;

  /// Retrofit's code generation 에서 사용하기 위한 String 을 반환하는 toJson 정의 (auth_repository.g.dart 에서 String 을 반환받기 위해 사용)
  String toJson() => type;
}

/// 소셜 로그인 API (auth/social/login) 시, 필요한 provider 에 대한 enum
enum AuthSnsProvider {
  none,
  kakao,
  naver,
  apple,
}

/// 휴대폰 인증 상태 관리를 위한 Enum
///
/// none: 초기 상태
/// sending: 전송 중
/// sent: 전송 완료
/// confirmed: 인증 성공
/// invalid: 인증 실패 - 인증번호 불일치
/// failed: 인증 실패 - 인증번호 불일치 외 타 오류 (기존재 휴대번호 등)
enum AuthVerificationNumberStatus { none, sending, sent, confirmed, invalid, failed }

/// 인증 상태 관리를 위한 Enum
///
/// none: 초기 상태
/// unverified: 인증 실패
/// verified: 인증 성공
enum AuthVerificationStatus { none, unverified, verified }