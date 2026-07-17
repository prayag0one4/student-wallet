import '../../../../core/database/sync_status.dart';
import 'split_type.dart';

class GroupExpense {
  final int? localId;
  final String? cloudId;
  final int groupId;
  final String title;
  final double amount;
  final int paidByMemberId;
  final SplitType splitType;
  final String? notes;
  final DateTime expenseDate;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final SyncStatus syncStatus;
  final int version;

  const GroupExpense({
    this.localId,
    this.cloudId,
    required this.groupId,
    required this.title,
    required this.amount,
    required this.paidByMemberId,
    required this.splitType,
    this.notes,
    required this.expenseDate,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.syncStatus = SyncStatus.localOnly,
    this.version = 1,
  });

  GroupExpense copyWith({
    int? localId,
    String? cloudId,
    int? groupId,
    String? title,
    double? amount,
    int? paidByMemberId,
    SplitType? splitType,
    String? notes,
    DateTime? expenseDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    SyncStatus? syncStatus,
    int? version,
  }) {
    return GroupExpense(
      localId: localId ?? this.localId,
      cloudId: cloudId ?? this.cloudId,
      groupId: groupId ?? this.groupId,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      paidByMemberId: paidByMemberId ?? this.paidByMemberId,
      splitType: splitType ?? this.splitType,
      notes: notes ?? this.notes,
      expenseDate: expenseDate ?? this.expenseDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
    );
  }
}
