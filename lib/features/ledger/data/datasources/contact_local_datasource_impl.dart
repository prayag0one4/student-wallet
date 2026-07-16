import 'package:isar/isar.dart';
import '../../../../core/database/database_service.dart';
import '../../../../core/database/entity_mapper.dart';
import '../../../../core/database/sync_status.dart';
import '../../../../core/logging/app_logger.dart';
import '../../domain/entities/contact.dart';
import '../models/contact_model.dart';
import 'contact_local_datasource.dart';

class ContactLocalDataSourceImpl implements ContactLocalDataSource {
  final DatabaseService _databaseService;
  final ContactMapper _mapper;
  final _logger = const AppLogger('ContactDS');

  ContactLocalDataSourceImpl(this._databaseService, this._mapper);

  Isar get _isar => _databaseService.instance;

  @override
  Future<List<Contact>> getAll({int? offset, int? limit}) async {
    final models = await _isar.contactModels
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
  Future<Contact?> getById(int id) async {
    final model = await _isar.contactModels.get(id);
    if (model == null || model.deletedAt != null) return null;
    return _mapper.toEntity(model);
  }

  @override
  Future<int> create(Contact contact) async {
    final model = _mapper.toModel(contact);
    await _isar.writeTxn(() async {
      model.createdAt = DateTime.now();
      model.syncStatus = SyncStatus.localOnly;
      model.version = 1;
      await _isar.contactModels.put(model);
    });
    return model.id;
  }

  @override
  Future<void> update(Contact contact) async {
    if (contact.localId == null) return;

    await _isar.writeTxn(() async {
      final existing = await _isar.contactModels.get(contact.localId!);
      if (existing == null || existing.deletedAt != null) return;

      existing.name = contact.name;
      existing.phone = contact.phone;
      existing.notes = contact.notes;
      existing.avatarColor = contact.avatarColor;
      existing.updatedAt = DateTime.now();
      existing.version += 1;
      await _isar.contactModels.put(existing);
    });
  }

  @override
  Future<void> delete(int id) async {
    await _isar.writeTxn(() async {
      final model = await _isar.contactModels.get(id);
      if (model != null) {
        model.deletedAt = DateTime.now();
        model.syncStatus = SyncStatus.deleted;
        await _isar.contactModels.put(model);
      }
    });
  }

  @override
  Future<List<Contact>> search(String query) async {
    if (query.isEmpty) return getAll();
    final models = await _isar.contactModels
        .where()
        .filter()
        .deletedAtIsNull()
        .and()
        .group((q) => q
            .nameContains(query, caseSensitive: false)
            .or()
            .phoneContains(query, caseSensitive: false))
        .sortByName()
        .findAll();
    return models.map(_mapper.toEntity).toList();
  }
}
