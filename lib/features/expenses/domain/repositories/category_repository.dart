import '../../../../core/errors/result.dart';
import '../entities/category.dart';

abstract class CategoryRepository {
  Future<Result<List<Category>>> getAll();
  Future<Result<Category?>> getById(int id);
  Future<Result<List<Category>>> getDefaults();
  Future<Result<Category>> save(Category category);
  Future<Result<void>> delete(int id);
}
