import 'package:dio/dio.dart' hide Headers;
import 'package:mediport/core/constant/data.dart';
import 'package:mediport/core/provider/dio_provider.dart';
import 'package:mediport/domain/model/category/res/category_res_list.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/base_res.dart';

part 'category_repository.g.dart';

@Riverpod(keepAlive: true)
CategoryRepository categoryRepository(CategoryRepositoryRef ref) => CategoryRepository(ref.watch(dioProvider), baseUrl: '$baseHostV1/category');

@RestApi()
abstract class CategoryRepository {
  factory CategoryRepository(Dio dio, { String baseUrl }) = _CategoryRepository;

  @GET('/list')
  @Headers({'authorization': 'true'})
  Future<BaseResponse<List<CategoryResList>>> list({
    @Query('diff') required String diff,
    @Query('primary') String? primary,
    @Query('name') String? name,
    @Query('search') String? search,
    @Query('startDate') String? startDate,
    @Query('endDate') String? endDate,
  });
}