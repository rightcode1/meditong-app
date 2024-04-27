import 'package:meditong/domain/model/example/req/example_req_list.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:meditong/core/provider/dio_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/http.dart';

part 'example_repository.g.dart';

// TODO: 각 도메인 별 Repository 는 도메인 별 하나씩만 존재하는 것이 좋다. (스웨거의 형태를 그대로 따라감)
final exampleRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  const String baseUrl = 'http://example.com/v1/example';

  return ExampleRepository(dio, baseUrl: baseUrl);
});

@RestApi()
abstract class ExampleRepository {
  factory ExampleRepository(Dio dio, {String baseUrl}) = _ExampleRepository;

  // TODO: Headers 의 경우, 추가적으로 Dio Interceptor 구현이 필요하다.
  @GET('/list')
  @Headers({'authorization': 'true'})
  Future<void> getList({
    @Body() required ExampleReqList body,
  });
}
