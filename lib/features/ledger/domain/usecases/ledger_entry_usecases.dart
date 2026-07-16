import '../../../../core/errors/result.dart';
import '../entities/ledger_entry.dart';
import '../repositories/ledger_entry_repository.dart';

class CreateLedgerEntry {
  final LedgerEntryRepository _repository;
  CreateLedgerEntry(this._repository);
  Future<Result<LedgerEntry>> call(LedgerEntry entry) => _repository.createEntry(entry);
}

class UpdateLedgerEntry {
  final LedgerEntryRepository _repository;
  UpdateLedgerEntry(this._repository);
  Future<Result<LedgerEntry>> call(LedgerEntry entry) => _repository.updateEntry(entry);
}

class DeleteLedgerEntry {
  final LedgerEntryRepository _repository;
  DeleteLedgerEntry(this._repository);
  Future<Result<void>> call(int id) => _repository.deleteEntry(id);
}

class GetLedgerEntryById {
  final LedgerEntryRepository _repository;
  GetLedgerEntryById(this._repository);
  Future<Result<LedgerEntry?>> call(int id) => _repository.getEntryById(id);
}

class GetAllLedgerEntries {
  final LedgerEntryRepository _repository;
  GetAllLedgerEntries(this._repository);
  Future<Result<List<LedgerEntry>>> call({int? offset, int? limit}) =>
      _repository.getAllEntries(offset: offset, limit: limit);
}

class GetLedgerEntriesByContact {
  final LedgerEntryRepository _repository;
  GetLedgerEntriesByContact(this._repository);
  Future<Result<List<LedgerEntry>>> call(int contactId, {int? offset, int? limit}) =>
      _repository.getEntriesByContact(contactId, offset: offset, limit: limit);
}

class GetRecentLedgerEntries {
  final LedgerEntryRepository _repository;
  GetRecentLedgerEntries(this._repository);
  Future<Result<List<LedgerEntry>>> call({int count = 5}) => _repository.getRecentEntries(count: count);
}

class GetOverdueEntries {
  final LedgerEntryRepository _repository;
  GetOverdueEntries(this._repository);
  Future<Result<List<LedgerEntry>>> call() => _repository.getOverdueEntries();
}

class GetTotalReceivable {
  final LedgerEntryRepository _repository;
  GetTotalReceivable(this._repository);
  Future<Result<double>> call() => _repository.getTotalReceivable();
}

class GetTotalPayable {
  final LedgerEntryRepository _repository;
  GetTotalPayable(this._repository);
  Future<Result<double>> call() => _repository.getTotalPayable();
}
