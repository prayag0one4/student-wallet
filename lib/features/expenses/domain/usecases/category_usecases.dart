import '../../../../core/errors/result.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

class GetAllCategories {
  final CategoryRepository _repository;
  GetAllCategories(this._repository);
  Future<Result<List<Category>>> call() => _repository.getAll();
}

class GetDefaultCategories {
  final CategoryRepository _repository;
  GetDefaultCategories(this._repository);
  Future<Result<List<Category>>> call() => _repository.getDefaults();
}

class GetCategoryById {
  final CategoryRepository _repository;
  GetCategoryById(this._repository);
  Future<Result<Category?>> call(int id) => _repository.getById(id);
}

class SaveCategory {
  final CategoryRepository _repository;
  SaveCategory(this._repository);
  Future<Result<Category>> call(Category category) => _repository.save(category);
}

class DeleteCategory {
  final CategoryRepository _repository;
  DeleteCategory(this._repository);
  Future<Result<void>> call(int id) => _repository.delete(id);
}
