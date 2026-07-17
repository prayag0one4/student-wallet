import 'package:isar/isar.dart';
import '../../../../core/database/database_service.dart';
import '../../../../core/database/entity_mapper.dart';
import '../../../../core/database/sync_status.dart';
import '../../domain/entities/group_entity.dart';
import '../models/group_model.dart';
import 'group_local_datasource.dart';

class GroupLocalDataSourceImpl implements GroupLocalDataSource {
  final DatabaseService _databaseService;
  final GroupMapper _mapper;

  GroupLocalDataSourceImpl(this._databaseService, this._mapper);

  Isar get _isar => _databaseService.instance;

  @override
  Future<List<Group>> getAll({int? offset, int? limit}) async {
    final models = await _isar.groupModels
        .where()
        .filter()
        .deletedAtIsNull()
        .sortByName()
        .offset(offset ?? 0)
        .limit(limit ?? 100000)
        .findAll();
    return models.map(_mapper.toEntity).toList();
  }

  @override
  Future<Group?> getById(int id) async {
    final model = await _isar.groupModels.get(id);
    if (model == null || model.deletedAt != null) return null;
    return _mapper.toEntity(model);
  }

  @override
  Future<int> create(Group group) async {
    final model = _mapper.toModel(group);
    await _isar.writeTxn(() async {
      model.createdAt = DateTime.now();
      model.syncStatus = SyncStatus.localOnly;
      model.version = 1;
      await _isar.groupModels.put(model);
    });
    return model.id;
  }

  @override
  Future<void> update(Group group) async {
    if (group.localId == null) return;
    await _isar.writeTxn(() async {
      final existing = await _isar.groupModels.get(group.localId!);
      if (existing == null || existing.deletedAt != null) return;
      existing.name = group.name;
      existing.icon = group.icon;
      existing.color = group.color;
      existing.description = group.description;
      existing.updatedAt = DateTime.now();
      existing.version += 1;
      await _isar.groupModels.put(existing);
    });
  }

  @override
  Future<void> delete(int id) async {
    await _isar.writeTxn(() async {
      final model = await _isar.groupModels.get(id);
      if (model != null) {
        model.deletedAt = DateTime.now();
        model.syncStatus = SyncStatus.deleted;
        await _isar.groupModels.put(model);
      }
    });
  }

  @override
  Future<List<Group>> search(String query) async {
    if (query.isEmpty) return getAll();
    final models = await _isar.groupModels
        .where()
        .filter()
        .deletedAtIsNull()
        .and()
        .nameContains(query, caseSensitive: false)
        .sortByName()
        .findAll();
    return models.map(_mapper.toEntity).toList();
  }
}
