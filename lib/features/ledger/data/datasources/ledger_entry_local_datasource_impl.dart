import 'package:isar/isar.dart';
import '../../../../core/database/database_service.dart';
import '../../../../core/database/entity_mapper.dart';
import '../../../../core/database/sync_status.dart';
import '../../../../core/logging/app_logger.dart';
import '../../domain/entities/ledger_entry.dart';
import '../models/ledger_entry_model.dart';
import 'ledger_entry_local_datasource.dart';

class LedgerEntryLocalDataSourceImpl implements LedgerEntryLocalDataSource {
  final DatabaseService _databaseService;
  final LedgerEntryMapper _mapper;

  LedgerEntryLocalDataSourceImpl(this._databaseService, this._mapper);

  Isar get _isar => _databaseService.instance;

  @override
  Future<List<LedgerEntry>> getAll({int? offset, int? limit}) async {
    final models = await _isar.ledgerEntryModels
        .where()
        .filter()
        .deletedAtIsNull()
        .sortByTransactionDateDesc()
        .offset(offset ?? 0)
        .limit(limit ?? 100000)
        .findAll();
    return models.map(_mapper.toEntity).toList();
  }

  @override
  Future<LedgerEntry?> getById(int id) async {
    final model = await _isar.ledgerEntryModels.get(id);
    if (model == null || model.deletedAt != null) return null;
    return _mapper.toEntity(model);
  }

  @override
  Future<int> create(LedgerEntry entry) async {
    final model = _mapper.toModel(entry);
    await _isar.writeTxn(() async {
      model.createdAt = DateTime.now();
      model.syncStatus = SyncStatus.localOnly;
      model.version = 1;
      await _isar.ledgerEntryModels.put(model);
    });
    return model.id;
  }

  @override
  Future<void> update(LedgerEntry entry) async {
    if (entry.localId == null) return;

    await _isar.writeTxn(() async {
      final existing = await _isar.ledgerEntryModels.get(entry.localId!);
      if (existing == null || existing.deletedAt != null) return;

      existing.contactId = entry.contactId;
      existing.type = entry.type.name;
      existing.amount = entry.amount;
      existing.description = entry.description;
      existing.notes = entry.notes;
      existing.transactionDate = entry.transactionDate;
      existing.dueDate = entry.dueDate;
      existing.updatedAt = DateTime.now();
      existing.version += 1;
      await _isar.ledgerEntryModels.put(existing);
    });
  }

  @override
  Future<void> delete(int id) async {
    await _isar.writeTxn(() async {
      final model = await _isar.ledgerEntryModels.get(id);
      if (model != null) {
        model.deletedAt = DateTime.now();
        model.syncStatus = SyncStatus.deleted;
        await _isar.ledgerEntryModels.put(model);
      }
    });
  }

  @override
  Future<List<LedgerEntry>> getByContact(int contactId, {int? offset, int? limit}) async {
    final models = await _isar.ledgerEntryModels
        .where()
        .filter()
        .deletedAtIsNull()
        .and()
        .contactIdEqualTo(contactId)
        .sortByTransactionDateDesc()
        .offset(offset ?? 0)
        .limit(limit ?? 100000)
        .findAll();
    return models.map(_mapper.toEntity).toList();
  }

  @override
  Future<List<LedgerEntry>> getRecent({int count = 5}) async {
    final models = await _isar.ledgerEntryModels
        .where()
        .filter()
        .deletedAtIsNull()
        .sortByTransactionDateDesc()
        .limit(count)
        .findAll();
    return models.map(_mapper.toEntity).toList();
  }

  @override
  Future<List<LedgerEntry>> getOverdue() async {
    final now = DateTime.now();
    final models = await _isar.ledgerEntryModels
        .where()
        .filter()
        .deletedAtIsNull()
        .and()
        .dueDateIsNotNull()
        .and()
        .dueDateLessThan(DateTime(now.year, now.month, now.day))
        .sortByDueDate()
        .findAll();
    return models.map(_mapper.toEntity).toList();
  }

  @override
  Future<double> getTotalReceivable() async {
    final models = await _isar.ledgerEntryModels
        .where()
        .filter()
        .deletedAtIsNull()
        .and()
        .typeEqualTo('received')
        .findAll();
    return models.fold<double>(0.0, (sum, m) => sum + m.amount);
  }

  @override
  Future<double> getTotalPayable() async {
    final models = await _isar.ledgerEntryModels
        .where()
        .filter()
        .deletedAtIsNull()
        .and()
        .typeEqualTo('paid')
        .findAll();
    return models.fold<double>(0.0, (sum, m) => sum + m.amount);
  }
}
