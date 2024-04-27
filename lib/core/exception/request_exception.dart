class RequestException implements Exception {
  String message;

  RequestException({
    required this.message,
  }) {
    message = '서버 요청 중 오류가 발생했습니다. err=$message';
  }
}
