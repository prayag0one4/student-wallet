import 'package:isar/isar.dart';
import '../../../../core/database/sync_status.dart';

part 'group_expense_model.g.dart';

@collection
class GroupExpenseModel {
  Id id = Isar.autoIncrement;

  @Index()
  String? cloudId;

  @Index()
  late int groupId;

  late String title;

  late double amount;

  late int paidByMemberId;

  late String splitType;

  String? notes;

  @Index()
  late DateTime expenseDate;

  late DateTime createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  @Enumerated(EnumType.name)
  SyncStatus syncStatus = SyncStatus.localOnly;

  int version = 1;
}
