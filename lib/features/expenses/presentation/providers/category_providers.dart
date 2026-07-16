import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/errors/result.dart';
import '../../domain/entities/category.dart';
import '../../domain/usecases/category_usecases.dart';

final categoryListProvider = FutureProvider<List<Category>>((ref) async {
  final usecase = GetIt.instance<GetAllCategories>();
  final result = await usecase();
  return _unwrap(result);
});

final defaultCategoriesProvider = FutureProvider<List<Category>>((ref) async {
  final usecase = GetIt.instance<GetDefaultCategories>();
  final result = await usecase();
  return _unwrap(result);
});

T _unwrap<T>(Result<T> result) {
  return result.fold(
    onSuccess: (data) => data,
    onFailure: (failure) => throw failure,
  );
}
