import 'package:isar/isar.dart';
import '../../../../core/database/sync_status.dart';

part 'expense_model.g.dart';

@collection
class ExpenseModel {
  Id id = Isar.autoIncrement;

  @Index()
  String? cloudId;

  @Index()
  late double amount;

  @Index()
  late int categoryId;

  @Index()
  late String description;

  late String paymentMethod;

  @Index()
  late DateTime expenseDate;

  String? merchantName;

  String? notes;

  List<String> tags = [];

  late DateTime createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  @Enumerated(EnumType.name)
  SyncStatus syncStatus = SyncStatus.localOnly;

  int version = 1;
}
