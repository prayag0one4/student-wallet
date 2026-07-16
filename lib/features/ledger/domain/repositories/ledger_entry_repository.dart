import '../../../../core/errors/result.dart';
import '../entities/ledger_entry.dart';

abstract class LedgerEntryRepository {
  Future<Result<List<LedgerEntry>>> getAllEntries({int? offset, int? limit});
  Future<Result<LedgerEntry>> createEntry(LedgerEntry entry);
  Future<Result<LedgerEntry>> updateEntry(LedgerEntry entry);
  Future<Result<void>> deleteEntry(int id);
  Future<Result<LedgerEntry?>> getEntryById(int id);
  Future<Result<List<LedgerEntry>>> getEntriesByContact(int contactId, {int? offset, int? limit});
  Future<Result<List<LedgerEntry>>> getRecentEntries({int count = 5});
  Future<Result<List<LedgerEntry>>> getOverdueEntries();
  Future<Result<double>> getTotalReceivable();
  Future<Result<double>> getTotalPayable();
}
