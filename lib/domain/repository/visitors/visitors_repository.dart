import 'package:mediport/core/constant/data.dart';
import 'package:mediport/core/provider/dio_provider.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'visitors_repository.g.dart';

@Riverpod(keepAlive: true)
VisitorsRepository visitorsRepository(VisitorsRepositoryRef ref) => VisitorsRepository(ref.watch(dioProvider), baseUrl: '$baseHostV1/visitors');

@RestApi()
abstract class VisitorsRepository {
  factory VisitorsRepository(Dio dio, { String baseUrl }) = _VisitorsRepository;

  @GET('')
  Future<void> visitors();
}