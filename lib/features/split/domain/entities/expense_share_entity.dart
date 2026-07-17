import '../../../../core/database/sync_status.dart';

class ExpenseShare {
  final int? localId;
  final int expenseId;
  final int memberId;
  final double amount;
  final double percentage;
  final double settledAmount;
  final SyncStatus syncStatus;

  const ExpenseShare({
    this.localId,
    required this.expenseId,
    required this.memberId,
    required this.amount,
    required this.percentage,
    this.settledAmount = 0,
    this.syncStatus = SyncStatus.localOnly,
  });

  ExpenseShare copyWith({
    int? localId,
    int? expenseId,
    int? memberId,
    double? amount,
    double? percentage,
    double? settledAmount,
    SyncStatus? syncStatus,
  }) {
    return ExpenseShare(
      localId: localId ?? this.localId,
      expenseId: expenseId ?? this.expenseId,
      memberId: memberId ?? this.memberId,
      amount: amount ?? this.amount,
      percentage: percentage ?? this.percentage,
      settledAmount: settledAmount ?? this.settledAmount,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }
}
