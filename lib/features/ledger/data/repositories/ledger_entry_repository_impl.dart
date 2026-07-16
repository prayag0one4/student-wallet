import '../../../../core/errors/failures.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/logging/app_logger.dart';
import '../../domain/entities/ledger_entry.dart';
import '../../domain/repositories/ledger_entry_repository.dart';
import '../datasources/ledger_entry_local_datasource.dart';

class LedgerEntryRepositoryImpl implements LedgerEntryRepository {
  final LedgerEntryLocalDataSource _localDataSource;
  final _logger = const AppLogger('LedgerEntryRepo');

  LedgerEntryRepositoryImpl(this._localDataSource);

  @override
  Future<Result<List<LedgerEntry>>> getAllEntries({int? offset, int? limit}) async {
    try {
      final entries = await _localDataSource.getAll(offset: offset, limit: limit);
      return Result.success(entries);
    } catch (e) {
      _logger.error('Failed to get all entries', e);
      return Result.failure(const DatabaseFailure(message: 'Failed to load entries'));
    }
  }

  @override
  Future<Result<LedgerEntry>> createEntry(LedgerEntry entry) async {
    try {
      final id = await _localDataSource.create(entry);
      return Result.success(entry.copyWith(localId: id));
    } catch (e) {
      _logger.error('Failed to create entry', e);
      return Result.failure(const DatabaseFailure(message: 'Failed to create entry'));
    }
  }

  @override
  Future<Result<LedgerEntry>> updateEntry(LedgerEntry entry) async {
    try {
      await _localDataSource.update(entry);
      return Result.success(entry.copyWith(updatedAt: DateTime.now()));
    } catch (e) {
      _logger.error('Failed to update entry', e);
      return Result.failure(const DatabaseFailure(message: 'Failed to update entry'));
    }
  }

  @override
  Future<Result<void>> deleteEntry(int id) async {
    try {
      await _localDataSource.delete(id);
      return Result.success(null);
    } catch (e) {
      _logger.error('Failed to delete entry: $id', e);
      return Result.failure(const DatabaseFailure(message: 'Failed to delete entry'));
    }
  }

  @override
  Future<Result<LedgerEntry?>> getEntryById(int id) async {
    try {
      final entry = await _localDataSource.getById(id);
      return Result.success(entry);
    } catch (e) {
      _logger.error('Failed to get entry by id: $id', e);
      return Result.failure(const DatabaseFailure(message: 'Failed to load entry'));
    }
  }

  @override
  Future<Result<List<LedgerEntry>>> getEntriesByContact(int contactId, {int? offset, int? limit}) async {
    try {
      final entries = await _localDataSource.getByContact(contactId, offset: offset, limit: limit);
      return Result.success(entries);
    } catch (e) {
      _logger.error('Failed to get entries for contact: $contactId', e);
      return Result.failure(const DatabaseFailure(message: 'Failed to load entries'));
    }
  }

  @override
  Future<Result<List<LedgerEntry>>> getRecentEntries({int count = 5}) async {
    try {
      final entries = await _localDataSource.getRecent(count: count);
      return Result.success(entries);
    } catch (e) {
      _logger.error('Failed to get recent entries', e);
      return Result.failure(const DatabaseFailure(message: 'Failed to load recent entries'));
    }
  }

  @override
  Future<Result<List<LedgerEntry>>> getOverdueEntries() async {
    try {
      final entries = await _localDataSource.getOverdue();
      return Result.success(entries);
    } catch (e) {
      _logger.error('Failed to get overdue entries', e);
      return Result.failure(const DatabaseFailure(message: 'Failed to load overdue entries'));
    }
  }

  @override
  Future<Result<double>> getTotalReceivable() async {
    try {
      final total = await _localDataSource.getTotalReceivable();
      return Result.success(total);
    } catch (e) {
      _logger.error('Failed to get total receivable', e);
      return Result.failure(const DatabaseFailure(message: 'Failed to compute receivable'));
    }
  }

  @override
  Future<Result<double>> getTotalPayable() async {
    try {
      final total = await _localDataSource.getTotalPayable();
      return Result.success(total);
    } catch (e) {
      _logger.error('Failed to get total payable', e);
      return Result.failure(const DatabaseFailure(message: 'Failed to compute payable'));
    }
  }
}
