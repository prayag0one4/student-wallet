import 'package:isar/isar.dart';
import '../../../../core/database/sync_status.dart';

part 'ledger_entry_model.g.dart';

@collection
class LedgerEntryModel {
  Id id = Isar.autoIncrement;

  @Index()
  String? cloudId;

  @Index()
  late int contactId;

  @Index()
  late String type;

  late double amount;

  late String description;

  String? notes;

  @Index()
  late DateTime transactionDate;

  DateTime? dueDate;

  late DateTime createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  @Enumerated(EnumType.name)
  SyncStatus syncStatus = SyncStatus.localOnly;

  int version = 1;
}
