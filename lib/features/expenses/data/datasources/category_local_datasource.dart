import '../../domain/entities/category.dart';

abstract class CategoryLocalDataSource {
  Future<List<Category>> getAll();
  Future<Category?> getById(int id);
  Future<List<Category>> getDefaults();
  Future<int> save(Category category);
  Future<void> delete(int id);
}
