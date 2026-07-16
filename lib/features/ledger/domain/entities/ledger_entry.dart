import '../../../../core/database/sync_status.dart';

enum LedgerEntryType { received, paid }

class LedgerEntry {
  final int? localId;
  final String? cloudId;
  final int contactId;
  final LedgerEntryType type;
  final double amount;
  final String description;
  final String? notes;
  final DateTime transactionDate;
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final SyncStatus syncStatus;
  final int version;

  const LedgerEntry({
    this.localId,
    this.cloudId,
    required this.contactId,
    required this.type,
    required this.amount,
    required this.description,
    this.notes,
    required this.transactionDate,
    this.dueDate,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.syncStatus = SyncStatus.localOnly,
    this.version = 1,
  });

  LedgerEntry copyWith({
    int? localId,
    String? cloudId,
    int? contactId,
    LedgerEntryType? type,
    double? amount,
    String? description,
    String? notes,
    DateTime? transactionDate,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    SyncStatus? syncStatus,
    int? version,
  }) {
    return LedgerEntry(
      localId: localId ?? this.localId,
      cloudId: cloudId ?? this.cloudId,
      contactId: contactId ?? this.contactId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      notes: notes ?? this.notes,
      transactionDate: transactionDate ?? this.transactionDate,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
    );
  }
}
