import 'package:isar/isar.dart';
import '../../../../core/database/sync_status.dart';

part 'expense_share_model.g.dart';

@collection
class ExpenseShareModel {
  Id id = Isar.autoIncrement;

  @Index()
  late int expenseId;

  @Index()
  late int memberId;

  late double amount;

  late double percentage;

  double settledAmount = 0;

  @Enumerated(EnumType.name)
  SyncStatus syncStatus = SyncStatus.localOnly;
}
