import 'package:isar/isar.dart';
import '../../../../core/database/database_service.dart';
import '../../../../core/database/sync_status.dart';
import '../../domain/entities/category.dart';
import '../models/category_model.dart';
import 'category_local_datasource.dart';

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  final DatabaseService _databaseService;

  CategoryLocalDataSourceImpl(this._databaseService);

  Isar get _isar => _databaseService.instance;

  @override
  Future<List<Category>> getAll() async {
    final models = await _isar.categoryModels
        .where()
        .filter()
        .deletedAtIsNull()
        .findAll();
    return models.map(_toEntity).toList();
  }

  @override
  Future<Category?> getById(int id) async {
    final model = await _isar.categoryModels.get(id);
    if (model == null || model.deletedAt != null) return null;
    return _toEntity(model);
  }

  @override
  Future<List<Category>> getDefaults() async {
    final models = await _isar.categoryModels
        .where()
        .filter()
        .isDefaultEqualTo(true)
        .and()
        .deletedAtIsNull()
        .findAll();
    return models.map(_toEntity).toList();
  }

  @override
  Future<int> save(Category category) async {
    final model = _toModel(category);
    await _isar.writeTxn(() async {
      model.createdAt = DateTime.now();
      model.syncStatus = SyncStatus.localOnly;
      model.version = 1;
      await _isar.categoryModels.put(model);
    });
    return model.id;
  }

  @override
  Future<void> delete(int id) async {
    await _isar.writeTxn(() async {
      final model = await _isar.categoryModels.get(id);
      if (model != null) {
        model.deletedAt = DateTime.now();
        model.syncStatus = SyncStatus.deleted;
        await _isar.categoryModels.put(model);
      }
    });
  }

  Category _toEntity(CategoryModel model) {
    return Category(
      localId: model.id,
      cloudId: model.cloudId,
      name: model.name,
      icon: model.icon,
      color: model.color,
      isDefault: model.isDefault,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      deletedAt: model.deletedAt,
      syncStatus: model.syncStatus,
      version: model.version,
    );
  }

  CategoryModel _toModel(Category entity) {
    final model = CategoryModel()
      ..id = entity.localId ?? Isar.autoIncrement
      ..cloudId = entity.cloudId
      ..name = entity.name
      ..icon = entity.icon
      ..color = entity.color
      ..isDefault = entity.isDefault
      ..createdAt = entity.createdAt
      ..updatedAt = entity.updatedAt
      ..deletedAt = entity.deletedAt
      ..syncStatus = entity.syncStatus
      ..version = entity.version;
    return model;
  }
}
