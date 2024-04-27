import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO: Provider 의 이름은 되도록 파일명을 따라가면 좋지만, 경우에 따라 반드시 그렇지는 않아도 된다.
// Provider 의 명칭은 [domain]_[API suffix]_provider.dart 로 지정한다.
// 예를 들어, 스웨거 내 Example API 에 https://example.com/v1/example/list 일 경우,
// example_list_provider.dart 로 명명한다.
final exampleListProvider = Provider((ref) => null);