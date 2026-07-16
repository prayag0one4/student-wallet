import '../../../../core/errors/failures.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/logging/app_logger.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_local_datasource.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDataSource _localDataSource;
  final _logger = const AppLogger('CategoryRepo');

  CategoryRepositoryImpl(this._localDataSource);

  @override
  Future<Result<List<Category>>> getAll() async {
    try {
      final categories = await _localDataSource.getAll();
      return Result.success(categories);
    } catch (e) {
      _logger.error('Failed to get all categories', e);
      return Result.failure(
        const DatabaseFailure(message: 'Failed to load categories'),
      );
    }
  }

  @override
  Future<Result<Category?>> getById(int id) async {
    try {
      final category = await _localDataSource.getById(id);
      return Result.success(category);
    } catch (e) {
      _logger.error('Failed to get category by id: $id', e);
      return Result.failure(
        const DatabaseFailure(message: 'Failed to load category'),
      );
    }
  }

  @override
  Future<Result<List<Category>>> getDefaults() async {
    try {
      final categories = await _localDataSource.getDefaults();
      return Result.success(categories);
    } catch (e) {
      _logger.error('Failed to get default categories', e);
      return Result.failure(
        const DatabaseFailure(message: 'Failed to load categories'),
      );
    }
  }

  @override
  Future<Result<Category>> save(Category category) async {
    try {
      final id = await _localDataSource.save(category);
      return Result.success(category.copyWith(localId: id));
    } catch (e) {
      _logger.error('Failed to save category', e);
      return Result.failure(
        const DatabaseFailure(message: 'Failed to save category'),
      );
    }
  }

  @override
  Future<Result<void>> delete(int id) async {
    try {
      await _localDataSource.delete(id);
      return Result.success(null);
    } catch (e) {
      _logger.error('Failed to delete category: $id', e);
      return Result.failure(
        const DatabaseFailure(message: 'Failed to delete category'),
      );
    }
  }
}
