import '../../../../core/constants/payment_method.dart';
import '../../../../core/database/sync_status.dart';

class Expense {
  final int? localId;
  final String? cloudId;
  final double amount;
  final int categoryId;
  final String description;
  final PaymentMethod paymentMethod;
  final DateTime expenseDate;
  final String? merchantName;
  final String? notes;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final SyncStatus syncStatus;
  final int version;

  const Expense({
    this.localId,
    this.cloudId,
    required this.amount,
    required this.categoryId,
    required this.description,
    this.paymentMethod = PaymentMethod.cash,
    required this.expenseDate,
    this.merchantName,
    this.notes,
    this.tags = const [],
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.syncStatus = SyncStatus.localOnly,
    this.version = 1,
  });

  Expense copyWith({
    int? localId,
    String? cloudId,
    double? amount,
    int? categoryId,
    String? description,
    PaymentMethod? paymentMethod,
    DateTime? expenseDate,
    String? merchantName,
    String? notes,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    SyncStatus? syncStatus,
    int? version,
  }) {
    return Expense(
      localId: localId ?? this.localId,
      cloudId: cloudId ?? this.cloudId,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      description: description ?? this.description,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      expenseDate: expenseDate ?? this.expenseDate,
      merchantName: merchantName ?? this.merchantName,
      notes: notes ?? this.notes,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
    );
  }
}
