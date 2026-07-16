import '../../domain/entities/ledger_entry.dart';

abstract class LedgerEntryLocalDataSource {
  Future<List<LedgerEntry>> getAll({int? offset, int? limit});
  Future<LedgerEntry?> getById(int id);
  Future<int> create(LedgerEntry entry);
  Future<void> update(LedgerEntry entry);
  Future<void> delete(int id);
  Future<List<LedgerEntry>> getByContact(int contactId, {int? offset, int? limit});
  Future<List<LedgerEntry>> getRecent({int count = 5});
  Future<List<LedgerEntry>> getOverdue();
  Future<double> getTotalReceivable();
  Future<double> getTotalPayable();
}
