import 'package:intl/intl.dart';

class DateUtil {
  /// yyyy-MM-dd 형태의 스트링인 [rawDashedDate] 를 전달받아 원하는 포매팅을 의미하는 스트링인 [expectedFormat] 형태로 변환한다.
  static String convertRawDashedDateIntoFormatted(String rawDashedDate, String expectedFormat) {
    final DateFormat dateFormatter = DateFormat(expectedFormat);
    final DateTime dateTime = DateTime.parse(rawDashedDate);

    return dateFormatter.format(dateTime);
  }

  /// [DateTime] 을 원하는 [String] 날짜 형태로 포매팅한다.
  ///
  /// 변경할 [DateTime] 인 [dateToBeConverted] 와, 변경할 포맷인 [expectedFormat] 을 전달받는다.
  static String convertDateTimeIntoFormatted(DateTime dateToBeConverted, String expectedFormat) {
    final DateFormat dateFormatter = DateFormat(expectedFormat);

    return dateFormatter.format(dateToBeConverted);
  }
}